package org.whalebank.backend.domain.notification.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.notification.NotificationEntity;
import org.whalebank.backend.domain.notification.dto.request.FCMRequestDto;
import org.whalebank.backend.domain.notification.repository.NotiRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class FcmUtils {

  private final FirebaseMessaging firebaseMessaging;
  private final NotiRepository notiRepository;

  public boolean sendNotificationByToken(UserEntity receiver, FCMRequestDto reqDto) {
    Notification notification = Notification.builder()
        .setTitle(reqDto.getTitle())
        .setBody(reqDto.getContent())
        .build();

    Message message = Message.builder()
        .setToken(receiver.getFcmToken())
        .setNotification(notification)
        .putData("category",reqDto.getCategory())
        .build();

    try {
      firebaseMessaging.send(message);

      notiRepository.save(NotificationEntity.from(reqDto, receiver));
      return true;
    } catch(FirebaseMessagingException e) {
      throw new CustomException(ResponseCode.NOTI_SEND_FAIL);
    }
  }

}
