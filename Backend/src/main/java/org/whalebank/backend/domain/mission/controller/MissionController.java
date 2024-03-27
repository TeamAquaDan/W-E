package org.whalebank.backend.domain.mission.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.mission.dto.request.MissionCreateRequestDto;
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

}
