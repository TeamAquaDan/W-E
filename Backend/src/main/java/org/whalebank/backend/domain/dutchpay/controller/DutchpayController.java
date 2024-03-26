package org.whalebank.backend.domain.dutchpay.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayRoomResponseDto;
import org.whalebank.backend.domain.dutchpay.service.DutchpayService;
import org.whalebank.backend.global.response.ApiResponse;

@Tag(name = "더치페이 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/dutchpay")
public class DutchpayController {

  private final DutchpayService dutchpayService;

  @Operation(summary = "더치페이 방 등록")
  @PostMapping
  public ApiResponse<DutchpayRoomResponseDto> createDutchpayRoom(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestBody DutchpayRoomRequestDto request) {
    return ApiResponse.ok("더치페이 방 생성 성공",
        dutchpayService.createDutchpayRoom(loginUser.getUsername(), request));
  }

}
