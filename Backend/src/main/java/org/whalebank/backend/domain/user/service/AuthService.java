package org.whalebank.backend.domain.user.service;


import org.whalebank.backend.domain.user.dto.request.LoginRequestDto;
import org.whalebank.backend.domain.user.dto.request.SignUpRequestDto;
import org.whalebank.backend.domain.user.dto.request.UpdatePasswordRequestDto;
import org.whalebank.backend.domain.user.dto.response.LoginResponseDto;
import org.whalebank.backend.domain.user.dto.response.ReissueResponseDto;

public interface AuthService {

  public void signUp(SignUpRequestDto dto);

  LoginResponseDto login(LoginRequestDto dto);

  ReissueResponseDto reissue(String refreshToken);

  void updatePassword(String loginId, UpdatePasswordRequestDto request);
}
