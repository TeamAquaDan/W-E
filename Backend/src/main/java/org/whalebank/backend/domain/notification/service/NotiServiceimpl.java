package org.whalebank.backend.domain.notification.service;

import jakarta.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.notification.FCMCategory;
import org.whalebank.backend.domain.notification.NotificationEntity;
import org.whalebank.backend.domain.notification.dto.request.FCMRequestDto;
import org.whalebank.backend.domain.notification.dto.response.NotiResponseDto;
import org.whalebank.backend.domain.notification.repository.NotiRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class NotiServiceimpl implements NotiService{

  private final NotiRepository notiRepository;
  private final AuthRepository userRepository;
  private final FcmUtils fcmUtils;

  @Override
  public List<NotiResponseDto> getAllNotification(String loginId) {
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    return notiRepository.findAllByUser(user)
        .stream().map(NotiResponseDto::from)
        .collect(Collectors.toList());
  }

  @Override
  @Transactional
  public void readNotification(String loginId, int notificationId) {
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    NotificationEntity noti = notiRepository.findById(notificationId)
        .orElseThrow(() -> new CustomException(ResponseCode.NOTI_NOT_FOUND));

    if(user.getUserId() != noti.getUser().getUserId()) {
      throw new CustomException(ResponseCode.NOTI_ACCESS_DENIED);
    }
    noti.readNotification();
  }

  @Override
  @Transactional
  public void readAll(String loginId) {
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    List<NotificationEntity> notiList = notiRepository.findAllByUser(user);
    for (NotificationEntity entity : notiList) {
      if (!entity.isRead()) {
        entity.readNotification();
      }
    }
  }

  @Scheduled(cron = "0 0 10 * * *")
  public void sendTodayWordNotification() {
    for(UserEntity user : userRepository.findAll()) {
      if(user.getFcmToken() == null) continue;
      fcmUtils.sendNotificationByToken(user,FCMRequestDto.of("오늘의 금융 단어는?","오늘의 단어를 확인해보세요!",FCMCategory.TODAY_WORD));
    }
  }
}
