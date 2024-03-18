package org.whalebank.backend.domain.user.security;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

  // 들어온 id로 userEntity를 찾아서 User 객체를 반환
  // 컨트롤러에서 넘어온 id와 password값이 db에 저장된 비밀번호와 일치한지 검사

  private final AuthRepository repository;

  @Override
  public UserDetails loadUserByUsername(String loginId) throws CustomException {
    UserEntity loginUser = repository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    return User.builder()
        .username(loginUser.getLoginId())
        .password(loginUser.getLoginPassword())
        .roles(String.valueOf(loginUser.getRole()))
        .build();
  }


}
