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

  private final GoalService goalService;

  @Operation(summary = "저축 목표 등록")
  @PostMapping("")
  public ApiResponse<GoalResponseDto> createGoal(
      @RequestBody GoalRequestDto goalRequest,
      @AuthenticationPrincipal UserDetails loginUser) {
    String loginId = loginUser.getUsername();

    return ApiResponse.ok("저축 목표 등록 성공", goalService.createGoal(goalRequest, loginId));
  }


}
