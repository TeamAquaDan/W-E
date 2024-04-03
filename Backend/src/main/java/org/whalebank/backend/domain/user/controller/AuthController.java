package org.whalebank.backend.domain.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.user.dto.request.LoginRequestDto;
import org.whalebank.backend.domain.user.dto.request.SignUpRequestDto;
import org.whalebank.backend.domain.user.dto.request.UpdatePasswordRequestDto;
import org.whalebank.backend.domain.user.dto.response.LoginResponseDto;
import org.whalebank.backend.domain.user.dto.response.ReissueResponseDto;
import org.whalebank.backend.domain.user.service.AuthService;
import org.whalebank.backend.global.response.ApiResponse;

@Tag(name = "인증 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthController {

  private final AuthService service;

  @Operation(summary = "회원가입", description = "로그인 아이디, 비밀번호, 이름, 주민등록번호 앞 6자리, 주민등록번호 뒤 7자리 입력")
  @PostMapping("/signup")
  public ApiResponse<?> signUp(@RequestBody SignUpRequestDto reqDto) {
    service.signUp(reqDto);
    return ApiResponse.ok("회원가입 성공");
  }

  @Operation(summary = "로그인", description = "아이디, 비밀번호 입력, 리프레시 토큰, 액세스 토큰, 유저 아이디, 프로필 사진, 이름 리턴")
  @PostMapping("/login")
  public ApiResponse<LoginResponseDto> login(@RequestBody LoginRequestDto reqDto) {
    return ApiResponse.ok("로그인 성공", service.login(reqDto));
  }

  @Operation(summary = "access token 재발급", description = "request body: refresh_token, access token, refresh token을 재발급한다")
  @PostMapping("/reissue")
  public ApiResponse<ReissueResponseDto> reissueAccessToken(@RequestBody Map<String, String> req) {
    return ApiResponse.ok("access token 재발급 성공", service.reissue(req.get("refresh_token")));
  }

  @Operation(summary = "비밀번호 변경")
  @PatchMapping("/login")
  public ApiResponse<?> updatePassword(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestBody UpdatePasswordRequestDto request) {

    service.updatePassword(loginUser.getUsername(), request);
    return ApiResponse.ok("비밀번호 변경 성공");
  }

}
