package org.whalebank.backend.domain.dutchpay.controller;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.PaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.RegisterPaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.SelfDutchpayRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayDetailResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayRoomResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.PaymentResponseDto;
import org.whalebank.backend.domain.dutchpay.service.DutchpayService;
import org.whalebank.backend.global.response.ApiResponse;

@Tag(name = "더치페이 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/dutchpay")
public class DutchpayController {

  private final DutchpayService dutchpayService;

  @Operation(summary = "더치페이 방 생성")
  @PostMapping
  public ApiResponse<DutchpayRoomResponseDto> createDutchpayRoom(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestBody DutchpayRoomRequestDto request) {
    return ApiResponse.ok("더치페이 방 생성 성공",
        dutchpayService.createDutchpayRoom(loginUser.getUsername(), request));
  }

  @Operation(summary = "더치페이 목록 조회")
  @GetMapping
  public ApiResponse<List<DutchpayRoomResponseDto>> getDutchpayRooms(
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("더치페이 목록 조회 성공",
        dutchpayService.getDutchpayRooms(loginUser.getUsername()));
  }

  @Operation(summary = "결제 내역 조회")
  @PostMapping("/my-payments")
  public ApiResponse<List<PaymentResponseDto>> getPayments(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestParam int dutchpayRoomId) {

    return ApiResponse.ok("결제 내역 조회 성공",
        dutchpayService.getPayments(loginUser.getUsername(), dutchpayRoomId));
  }

  @Operation(summary = "더치페이 금액 및 계좌 등록")
  @PostMapping("/register")
  public ApiResponse<?> registerPayments(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestBody RegisterPaymentRequestDto request) {

    dutchpayService.registerPayments(loginUser.getUsername(), request);
    return ApiResponse.ok("더치페이 금액 및 계좌 등록 성공");
  }

  @Operation(summary = "더치페이 방 상세 조회")
  @GetMapping("/{room_id}")
  public ApiResponse<List<DutchpayDetailResponseDto>> getDutchpayRoom(
      @AuthenticationPrincipal UserDetails loginUser,
      @PathVariable("room_id") int roomId) {

    List<DutchpayDetailResponseDto> dutchpayRoom = dutchpayService.getDutchpayRoom(
        loginUser.getUsername(), roomId);

    return ApiResponse.ok("더치페이 방 상세 조회", dutchpayRoom);
  }

  @Operation(summary = "타인 결제 내역 조회")
  @PostMapping("/payments")
  public ApiResponse<List<PaymentResponseDto>> viewPayments(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestBody PaymentRequestDto request) {

    List<PaymentResponseDto> payments = dutchpayService.viewPayments(loginUser.getUsername(),
        request);

    return ApiResponse.ok("선택한 결제 내역 조회 성공", payments);
  }


  @Operation(summary = "자동 정산")
  @PatchMapping("/{room_id}")
  public ApiResponse<List<DutchpayDetailResponseDto>> autoDutchpay(
      @AuthenticationPrincipal UserDetails loginUser,
      @PathVariable("room_id") int roomId) {

    List<DutchpayDetailResponseDto> dutchpayRoom = dutchpayService.autoDutchpay(
        loginUser.getUsername(), roomId);

    return ApiResponse.ok("자동 정산 성공", dutchpayRoom);
  }

  @Operation(summary = "수동 정산")
  @PatchMapping("/self/{dutchpay_id}")
  public ApiResponse<List<DutchpayDetailResponseDto>> selfDutchpay(
      @AuthenticationPrincipal UserDetails loginUser,
      @RequestBody SelfDutchpayRequestDto request,
      @PathVariable("dutchpay_id") int dutchpayId) {

    List<DutchpayDetailResponseDto> dutchpayRoom = dutchpayService.selfDutchpay(
        loginUser.getUsername(), request, dutchpayId);

    return ApiResponse.ok("수동 정산 성공", dutchpayRoom);
  }

}
