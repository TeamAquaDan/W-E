package org.whalebank.backend.domain.notification.service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
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

  @Override
  public List<NotiResponseDto> getAllNotification(String loginId) {
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    return notiRepository.findAllByUser(user)
        .stream().map(NotiResponseDto::from)
        .collect(Collectors.toList());
  }
}
