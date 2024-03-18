package org.whalebank.backend.domain.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.user.dto.request.VerifyRequestDto;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;
import org.whalebank.backend.domain.user.dto.response.VerifyResponseDto;
import org.whalebank.backend.domain.user.service.UserService;
import org.whalebank.backend.global.response.ApiResponse;

@Tag(name="유저 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {

  private final UserService service;

  @Operation(summary="프로필 조회", description="프로필 조회(유저 아이디, 유저 이름, 프로필 사진, 생년월일, 프로필 수정 가능 여부). 내 프로필일 경우 editable이 true")
  @PostMapping("/profile")
  public ApiResponse<ProfileResponseDto> getUserProfile(@RequestBody Map<String, Integer> reqDto, @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername(); // 로그인한 사람
    return ApiResponse.ok("프로필 조회 성공", service.getProfile(reqDto.get("user_id"), loginId));
  }

  @Operation(summary="실명 인증", description = "전화번호, 이름으로 실명 인증")
  @PostMapping("/verify")
  public ApiResponse<VerifyResponseDto> verifyUserWithPhoneNumAndName(@RequestBody VerifyRequestDto reqDto) {
    return ApiResponse.ok("실명 인증 성공", service.verifyUser(reqDto));
  }

}
