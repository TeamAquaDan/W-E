package org.whalebank.backend.domain.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.whalebank.backend.domain.user.dto.request.RegisterMainAccountRequestDto;
import org.whalebank.backend.domain.user.dto.request.VerifyRequestDto;
import org.whalebank.backend.domain.user.dto.response.ProfileImageResponseDto;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;
import org.whalebank.backend.domain.user.dto.response.VerifyResponseDto;
import org.whalebank.backend.domain.user.service.UserService;
import org.whalebank.backend.global.response.ApiResponse;

@Tag(name = "유저 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {

  private final UserService service;

  @Operation(summary = "프로필 사진 등록")
  @PatchMapping("/profile-img")
  public ApiResponse<ProfileImageResponseDto> updateProfile(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestParam("Content-Type") MultipartFile file) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("프로필 사진 등록 성공", service.updateProfileImage(loginId, file));
  }

  @Operation(summary = "한줄소개 등록")
  @PatchMapping("/profile/sentence")
  public ApiResponse<?> updateSentence(@AuthenticationPrincipal UserDetails loginUser,
      @RequestBody Map<String, String> request) {
    String loginId = loginUser.getUsername();

    service.updateSentence(loginId, request.get("sentence"));
    return ApiResponse.ok("한줄소개 등록 성공");
  }


  @Operation(summary = "프로필 조회", description = "프로필 조회(유저 아이디, 유저 이름, 프로필 사진, 생년월일, 프로필 수정 가능 여부). 내 프로필일 경우 editable이 true")
  @PostMapping("/profile")
  public ApiResponse<ProfileResponseDto> getUserProfile(@RequestBody Map<String, Integer> reqDto,
      @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername(); // 로그인한 사람
    return ApiResponse.ok("프로필 조회 성공", service.getProfile(reqDto.get("user_id"), loginId));
  }

  @Operation(summary = "실명 인증", description = "전화번호, 이름으로 실명 인증")
  @PostMapping("/verify")
  public ApiResponse<VerifyResponseDto> verifyUserWithPhoneNumAndName(
      @RequestBody VerifyRequestDto reqDto) {
    return ApiResponse.ok("실명 인증 성공", service.verifyUser(reqDto));
  }

  @Operation(summary = "주계좌 등록", description = "계좌 목록 조회 api로 받아온 계좌 중 하나를 주 계좌로 등록한다")
  @PatchMapping("/main-account")
  public ApiResponse<?> registerMainAccount(@AuthenticationPrincipal UserDetails loginUser,
      @RequestBody RegisterMainAccountRequestDto requestBody) {
    service.updateMainAccount(loginUser.getUsername(), requestBody);
    return ApiResponse.ok("주계좌 등록 성공");
  }

}
