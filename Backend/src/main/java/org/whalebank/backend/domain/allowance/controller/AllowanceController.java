package org.whalebank.backend.domain.allowance.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.allowance.dto.request.AddGroupRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateAllowanceRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateNicknameRequestDto;
import org.whalebank.backend.domain.allowance.dto.response.AllowanceInfoResponseDto;
import org.whalebank.backend.domain.allowance.dto.response.ChildrenDetailResponseDto;
import org.whalebank.backend.domain.allowance.dto.response.ChildrenInfoResponseDto;
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

  @PatchMapping("/nickname")
  @Operation(summary = "별칭 수정", description = "그룹에 대한 별칭을 수정한다")
  public ApiResponse<?> updateNickname(
      @RequestBody UpdateNicknameRequestDto reqDto,
      @AuthenticationPrincipal UserDetails loginUser
  ) {
    allowanceService.updateNickname(reqDto, loginUser.getUsername());
    return ApiResponse.ok("별칭 수정 성공");
  }

  @GetMapping("/list")
  @Operation(summary = "용돈 목록 조회", description = "자녀는 용돈을 주는 사람과 주기, 금액을 조회한다")
  public ApiResponse<List<AllowanceInfoResponseDto>> getAllowanceList(
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("용돈 목록 조회 성공",
        allowanceService.getAllowanceList(loginUser.getUsername()));
  }

  @GetMapping("/children")
  @Operation(summary = "자녀 목록 조회", description = "부모님이 용돈을 받고 있는 자녀를 조회한다")
  public ApiResponse<List<ChildrenInfoResponseDto>> getChildrenList(
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("자녀 목록 조회 성공",
        allowanceService.getChildrenList(loginUser.getUsername())
        );
  }

  @GetMapping("/children/{group_id}/{user_id}")
  @Operation(summary = "자녀 상세 조회", description = "부모님이 자녀의 상세 정보(계좌번호, 용돈 주기, 금액 등)를 조회한다")
  public ApiResponse<ChildrenDetailResponseDto> getChildrenDetail(
      @AuthenticationPrincipal UserDetails loginUser,
      @PathVariable("group_id") int groupId,
      @PathVariable("user_id") int childId) {
    return ApiResponse.ok("자녀 상세 조회 성공",
        allowanceService.getChildDetail(loginUser.getUsername(), groupId, childId));
  }

}