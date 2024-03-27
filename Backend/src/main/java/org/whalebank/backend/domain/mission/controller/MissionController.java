package org.whalebank.backend.domain.mission.controller;

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
import org.whalebank.backend.domain.mission.dto.request.MissionCreateRequestDto;
import org.whalebank.backend.domain.mission.dto.request.MissionManageRequestDto;
import org.whalebank.backend.domain.mission.dto.response.MissionInfoResponseDto;
import org.whalebank.backend.domain.mission.service.MissionService;
import org.whalebank.backend.global.response.ApiResponse;

@RestController
@Tag(name = "미션 관련 API")
@RequiredArgsConstructor
@RequestMapping("/api/mission")
public class MissionController {

  private final MissionService missionService;

  @PostMapping("")
  @Operation(summary = "미션 등록(부모만 가능)", description = "부모가 미션을 등록한다")
  public ApiResponse<MissionInfoResponseDto> createMission(
      @RequestBody MissionCreateRequestDto reqDto,
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("미션 등록 성공", missionService.createMission(reqDto, loginUser.getUsername()));
  }

  @GetMapping("/{group_id}")
  @Operation(summary = "미션 조회(부모, 자녀 모두 가능)", description = "그룹에 속하는 모든 미션 목록 마감일 순으로 조회한다")
  public ApiResponse<List<MissionInfoResponseDto>> getAllMissionByGroupId(
      @PathVariable("group_id") int groupId,
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("미션 조회 성공",
        missionService.getAllMission(groupId, loginUser.getUsername()));
  }

  @PatchMapping("")
  @Operation(summary = "미션 관리(성공/실패)", description = "미션을 성공 처리하거나 실패 처리한다")
  public ApiResponse<MissionInfoResponseDto> manageMission(
      @RequestBody MissionManageRequestDto reqDto,
      @AuthenticationPrincipal UserDetails loginUser
  ) {
    return ApiResponse.ok("미션 처리 완료",
        missionService.manageMission(reqDto, loginUser.getUsername()));
  }

}
