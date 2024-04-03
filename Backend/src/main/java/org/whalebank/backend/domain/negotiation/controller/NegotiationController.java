package org.whalebank.backend.domain.negotiation.controller;

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
import org.whalebank.backend.domain.negotiation.dto.request.NegoManageRequestDto;
import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoInfoResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoListResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoResponseDto;
import org.whalebank.backend.domain.negotiation.service.NegotiationService;
import org.whalebank.backend.global.response.ApiResponse;

@RestController
@RequestMapping("/api/nego")
@Tag(name = "용돈 인상 요청 관련 API")
@RequiredArgsConstructor
public class NegotiationController {

  private final NegotiationService negotiationService;

  @PostMapping("")
  @Operation(summary = "용돈 인상 요청", description = "그룹 아이디, 요청 액수, 요청 사유를 입력한다")
  public ApiResponse<NegoResponseDto> requestNegotiation(@RequestBody NegoRequestDto reqDto,
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("인상 요청 성공",
        negotiationService.requestNegotiation(reqDto, loginUser.getUsername()));
  }

  @GetMapping("/{group_id}")
  @Operation(summary = "용돈 인상 요청 내역 조회", description = "그룹 내 모든 용돈 인상 요청 내역을 조회한다")
  public ApiResponse<List<NegoListResponseDto>> getNegoListInGroup(
      @AuthenticationPrincipal UserDetails loginUser, @PathVariable("group_id") int groupId) {
    return ApiResponse.ok("인상 요청 내역 조회 성공",
        negotiationService.findAllNegoList(groupId, loginUser.getUsername()));
  }

  @GetMapping("/{group_id}/{nego_id}")
  @Operation(summary = "인상 요청 조회", description = "인상 요청")
  public ApiResponse<NegoInfoResponseDto> getNegoDetail(@PathVariable("group_id") int groupId,
      @PathVariable("nego_id") int negoId,
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("인상 요청 조회 성공",
        negotiationService.findNegoByNegoId(groupId, negoId, loginUser.getUsername()));
  }

  @PatchMapping("/manage")
  @Operation(summary = "인상 요청 처리", description = "인상 요청을 거절하거나 승인한다")
  public ApiResponse<?> manageNegotiation(@AuthenticationPrincipal UserDetails loginUser,
      @RequestBody NegoManageRequestDto requestDto) {
    negotiationService.updateNegotiation(requestDto, loginUser.getUsername());
    return ApiResponse.ok("용돈 인상 처리 성공");
  }

}
