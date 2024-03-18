package org.whalebank.backend.domain.user.service;


import org.whalebank.backend.domain.user.dto.request.LoginRequestDto;
import org.whalebank.backend.domain.user.dto.request.SignUpRequestDto;
import org.whalebank.backend.domain.user.dto.response.LoginResponseDto;

public interface AuthService {

  public void signUp(SignUpRequestDto dto);

  LoginResponseDto login(LoginRequestDto dto);

}
