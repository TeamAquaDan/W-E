package org.whalebank.backend.domain.accountbook.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.accountbook.dto.request.AccountBookEntryRequestDto;
import org.whalebank.backend.domain.accountbook.dto.response.AccountBookEntryResponseDto;
import org.whalebank.backend.domain.accountbook.dto.response.MonthlyHistoryResponseDto;
import org.whalebank.backend.domain.accountbook.service.AccountBookService;
import org.whalebank.backend.global.response.ApiResponse;


@Tag(name = "가계부 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/accountbook")
public class AccountBookController {

  private final AccountBookService service;

  @GetMapping("/history")
  @Operation(summary = "월별 수입/지출내역 조회", description = "선택한 연,월에 해당하는 입금 내역, 카드 지출 내역을 조회한다")
  public ApiResponse<MonthlyHistoryResponseDto> getMonthlyHistory(
      @RequestParam(name = "year") int year,
      @RequestParam(name = "month") int month,
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("수입/지출 내역 조회 성공",
        service.getIncomeAndExpenseHistory(loginUser.getUsername(), year, month));
  }

  @PostMapping
  @Operation(summary = "수입/지출 내역 등록")
  public ApiResponse<?> createAccountBookEntry(@AuthenticationPrincipal UserDetails loginUser,
      @RequestBody AccountBookEntryRequestDto request) {

    service.createAccountBookEntry(loginUser.getUsername(), request);

    return ApiResponse.ok("수입/지출 내역 등록 성공");
  }

  @GetMapping("/{account_book_id}")
  @Operation(summary = "수입/지출 내역 상세 조회")
  public ApiResponse<AccountBookEntryResponseDto> getAccountBookEntry(
      @RequestParam int accountBookId,
      @AuthenticationPrincipal UserDetails loginUser) {

    return ApiResponse.ok("수입/지출 내역 상세 조회 성공",
        service.getAccountBookEntry(accountBookId, loginUser.getUsername()));
  }

  @PatchMapping("/{account_book_id}")
  @Operation(summary = "수입/지출 내역 수정")
  public ApiResponse<AccountBookEntryResponseDto> updateAccountBookEntry(
      @RequestParam int accountBookId,
      @RequestBody AccountBookEntryRequestDto request,
      @AuthenticationPrincipal UserDetails loginUser) {

    return ApiResponse.ok("수입/지출 내역 수정 성공",
        service.updateAccountBookEntry(accountBookId, request, loginUser.getUsername()));
  }

  @DeleteMapping("/{account_book_id}")
  @Operation(summary = "수입/지출 내역 삭제")
  public ApiResponse<?> deleteAccountBookEntry(@RequestParam int accountBookId,
      @AuthenticationPrincipal UserDetails loginUser) {

    service.deleteAccountBookEntry(accountBookId, loginUser.getUsername());
    return ApiResponse.ok("수입/지출 내역 삭제 성공");
  }

}
