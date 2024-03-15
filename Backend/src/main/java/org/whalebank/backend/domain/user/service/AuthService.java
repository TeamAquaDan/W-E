package org.whalebank.backend.domain.user.service;


import org.whalebank.backend.domain.user.dto.request.SignUpRequestDto;

public interface AuthService {

  public void signUp(SignUpRequestDto dto);

}
