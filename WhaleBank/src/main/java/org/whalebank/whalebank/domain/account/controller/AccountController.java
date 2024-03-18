package org.whalebank.whalebank.domain.account.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.service.AccountService;

@RestController
@RequestMapping("/whale/bank/accounts")
@RequiredArgsConstructor
public class AccountController {

  private final AccountService accountService;

  @GetMapping
  public ResponseEntity<AccountResponse> getAccounts(HttpServletRequest request) {
    return new ResponseEntity<>(accountService.getAccounts(request), HttpStatus.OK);
  }
}
