package org.whalebank.backend.domain.user.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.user.dto.request.LoginRequestDto;
import org.whalebank.backend.domain.user.dto.request.SignUpRequestDto;
import org.whalebank.backend.domain.user.dto.response.LoginResponseDto;
import org.whalebank.backend.domain.user.service.AuthService;
import org.whalebank.backend.global.response.ApiResponse;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthController {

  private final AuthService service;

  @PostMapping("/signup")
  public ApiResponse<?> signUp(@RequestBody SignUpRequestDto reqDto) {
    service.signUp(reqDto);
    return ApiResponse.ok("회원가입 성공");
  }

  @PostMapping("/login")
  public ApiResponse<LoginResponseDto> login(@RequestBody LoginRequestDto reqDto) {
    return ApiResponse.ok("로그인 성공", service.login(reqDto));
  }

}
