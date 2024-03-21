package org.whalebank.backend.domain.goal.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.goal.dto.response.GoalResponseDto;
import org.whalebank.backend.domain.goal.service.GoalService;
import org.whalebank.backend.global.response.ApiResponse;

@Tag(name = "저축 목표 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/goal")
public class GoalController {

  private GoalService goalService;

//  @Operation(summary="프로필 조회", description="프로필 조회(유저 아이디, 유저 이름, 프로필 사진, 생년월일, 프로필 수정 가능 여부). 내 프로필일 경우 editable이 true")
//  @PostMapping("/profile")
//  public ApiResponse<ProfileResponseDto> getUserProfile(@RequestBody Map<String, Integer> reqDto,
//  @AuthenticationPrincipal UserDetails loginUser) {
//    String loginId = loginUser.getUsername(); // 로그인한 사람
//    return ApiResponse.ok("프로필 조회 성공", service.getProfile(reqDto.get("user_id"), loginId));
//  }

  @Operation(summary = "저축 목표 등록")
  @PostMapping("")
  public ApiResponse<GoalResponseDto> createGoal(
      @RequestBody GoalRequestDto goalRequest,
      @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("저축 목표 등록 성공", goalService.createGoal(goalRequest, loginId));
  }


}
