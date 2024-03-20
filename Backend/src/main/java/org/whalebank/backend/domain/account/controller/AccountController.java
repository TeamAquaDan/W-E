package org.whalebank.backend.domain.account.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.account.dto.request.InquiryRequestDto;
import org.whalebank.backend.domain.account.dto.request.TransactionHistoryRequestDto;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;
import org.whalebank.backend.domain.account.dto.response.AccountDetailResponseDto;
import org.whalebank.backend.domain.account.dto.response.AccountInfoResponseDto;
import org.whalebank.backend.domain.account.dto.response.InquiryResponseDto;
import org.whalebank.backend.domain.account.dto.response.TransactionHistoryResponseDto;
import org.whalebank.backend.domain.account.service.AccountService;
import org.whalebank.backend.global.response.ApiResponse;

@RestController
@RequestMapping("/api/account")
@Tag(name="계좌, 송금 관련 api")
@RequiredArgsConstructor
public class AccountController {

  private final AccountService service;

  @GetMapping("")
  @Operation(summary="계좌 목록 조회", description = "내가 소유한 계좌들을 조회한다")
  public ApiResponse<List<AccountInfoResponseDto>> getAccountList(@AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("계좌 목록 조회 성공",service.getAllAccounts(loginUser.getUsername()));
  }

  @GetMapping("/detail")
  @Operation(summary = "계좌 상세 조회", description = "선택한 계좌의 상세 정보를 조회함")
  public ApiResponse<AccountDetailResponseDto> getAccountDetail(
      @AuthenticationPrincipal UserDetails loginUser, @RequestBody Map<String, Integer> reqDto) {
    return ApiResponse.ok("계좌 상세 조회 성공", service.getAccountDetail(loginUser.getUsername(), reqDto.get("account_id")));
  }

  @PostMapping("/transfer/inquiry/receive")
  @Operation(summary = "수취인 조회", description = "송금 전 수취인의 계좌번호가 유효한지 확인한다")
  public ApiResponse<InquiryResponseDto> inquiry(
      @AuthenticationPrincipal UserDetails loginUser, @RequestBody InquiryRequestDto requestDto
  ) {
    return ApiResponse.ok("수취인 조회 성공", service.inquiryReceiver(loginUser.getUsername(), requestDto));
  }

  @PostMapping("/transfer/withdraw")
  @Operation(summary = "송금", description = "수취인 조회가 성공한다면 송금")
  public ApiResponse<?> withdraw(
      @AuthenticationPrincipal UserDetails loginUser, @RequestBody WithdrawRequestDto reqDto
  ) {
    service.withdraw(loginUser.getUsername(), reqDto);
    return ApiResponse.ok("송금 성공");
  }

  @GetMapping("/history")
  @Operation(summary = "계좌 거래내역 조회", description = "조회 시작일부터 마지막일까지의 거래 내역을 조회한다")
  public ApiResponse<List<TransactionHistoryResponseDto>> getTransactionHistory(
      @AuthenticationPrincipal UserDetails loginUser, @RequestBody TransactionHistoryRequestDto reqDto
  ) {
    return ApiResponse.ok("거래 내역 조회 성공", service.getTransactionHistory(loginUser.getUsername(), reqDto));
  }

  @GetMapping("/parking")
  @Operation(summary = "파킹통장 잔액 조회", description = "계좌고유번호가 account_id인 계좌의 파킹통장 잔액을 조회한다")
  public ApiResponse<?> getParkingBalance(
      @AuthenticationPrincipal UserDetails loginUser, @RequestBody Map<String, Integer> requestBody
  ) {
    return ApiResponse.ok("파킹 통장 잔액 조회 성공",
        service.getParkingBalance(loginUser.getUsername(), requestBody.get("account_id")));
  }

}
