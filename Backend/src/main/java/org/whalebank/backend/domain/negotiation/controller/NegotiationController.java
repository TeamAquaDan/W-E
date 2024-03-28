package org.whalebank.backend.domain.negotiation.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;
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

}
