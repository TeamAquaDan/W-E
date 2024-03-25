package org.whalebank.backend.domain.allowance.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.allowance.dto.request.AddGroupRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateAllowanceRequestDto;
import org.whalebank.backend.domain.allowance.dto.response.GroupInfoResponseDto;
import org.whalebank.backend.domain.allowance.service.AllowanceService;
import org.whalebank.backend.global.response.ApiResponse;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/allowance")
@Tag(name="그룹 관리 api")
public class AllowanceController {

  private final AllowanceService allowanceService;

  @PostMapping("/add")
  @Operation(summary="자녀 추가")
  public ApiResponse<GroupInfoResponseDto> addChild(@RequestBody AddGroupRequestDto reqDto, @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("자녀 추가 성공", allowanceService.registerGroup(reqDto, loginUser.getUsername()));
  }

  @PatchMapping("/info")
  @Operation(summary = "용돈 정보 수정", description = "용돈 주기, 금액, 지급일을 수정한다")
  public ApiResponse<GroupInfoResponseDto> updateAllowanceInfo(
      @RequestBody UpdateAllowanceRequestDto requestDto,
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("용돈 정보 수정 성공", allowanceService.updateGroup(requestDto,
        loginUser.getUsername()));
  }

}
