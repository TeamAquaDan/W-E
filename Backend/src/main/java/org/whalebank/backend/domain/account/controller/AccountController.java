package org.whalebank.backend.domain.account.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.account.dto.response.AccountInfoResponseDto;
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



}
