package org.whalebank.backend.domain.goal.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.goal.dto.request.GoalSaveRequestDto;
import org.whalebank.backend.domain.goal.dto.request.GoalStatusRequestDto;
import org.whalebank.backend.domain.goal.dto.response.GoalDetailResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalListResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalSaveResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalStatusResponseDto;
import org.whalebank.backend.domain.goal.service.GoalService;
import org.whalebank.backend.global.response.ApiResponse;

@Tag(name = "저축 목표 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/goal")
public class GoalController {

  private final GoalService goalService;

  @Operation(summary = "저축 목표 등록")
  @PostMapping
  public ApiResponse<GoalResponseDto> createGoal(
      @RequestBody GoalRequestDto goalRequest,
      @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("저축 목표 등록 성공", goalService.createGoal(goalRequest, loginId));
  }

  @Operation(summary = "저축 목표 목록 조회")
  @GetMapping("/search")
  public ApiResponse<GoalListResponseDto> getGoals(
      @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("저축 목표 목록 조회 성공", goalService.getGoals(loginId));
  }

  @Operation(summary = "저축 목표 상세 조회")
  @GetMapping("/{goal_id}")
  public ApiResponse<GoalDetailResponseDto> getGoal(
      @AuthenticationPrincipal UserDetails loginUser,
      @PathVariable(name = "goal_id") int goalId) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("저축 목표 상세 조회 성공", goalService.getGoal(loginId, goalId));
  }

  @Operation(summary = "목표 금액 저금하기")
  @PatchMapping("/save")
  public ApiResponse<GoalSaveResponseDto> saveMoney(
      @RequestBody GoalSaveRequestDto saveRequest,
      @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("저금 성공", goalService.saveMoney(saveRequest, loginId));
  }

  @Operation(summary = "목표 상태 수정하기")
  @PatchMapping
  public ApiResponse<GoalStatusResponseDto> updateStatus(
      @RequestBody GoalStatusRequestDto statusRequest,
      @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("출금 성공", goalService.updateStatus(statusRequest, loginId));
  }
}
