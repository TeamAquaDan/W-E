package org.whalebank.backend.domain.accountbook.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.accountbook.dto.response.MonthlyHistoryResponseDto;
import org.whalebank.backend.domain.accountbook.service.AccountBookService;
import org.whalebank.backend.global.response.ApiResponse;


@Tag(name="가계부 관련 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/accountbook")
public class AccountBookController {

  private final AccountBookService service;

  @GetMapping("/history")
  @Operation(summary = "월별 수입/지출내역 조회", description = "선택한 연,월에 해당하는 입금 내역, 카드 지출 내역을 조회한다")
  public ApiResponse<MonthlyHistoryResponseDto> getMonthlyHistory(@RequestParam(name="year") int year,
      @RequestParam(name="month") int month,
      @AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("수입/지출 내역 조회 성공", service.getIncomeAndExpenseHistory(loginUser.getUsername(), year, month));
  }

}
