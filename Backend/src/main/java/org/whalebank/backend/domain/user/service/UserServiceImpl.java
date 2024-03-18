package org.whalebank.backend.domain.user.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService {

  private final AuthRepository repository;

  public ProfileResponseDto getProfile(int userId, String loginId) {
    boolean editable = true;
    // 현재 로그인한 사용자
    UserEntity user = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    if(user.getUserId() != userId) {
      // 친구 프로필 조회
      user = repository.findById(userId)
          .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
      editable = false;
    }

    return ProfileResponseDto.of(user, editable);
  }

}
