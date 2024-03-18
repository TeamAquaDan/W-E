package org.whalebank.whalebank.domain.account.controller;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.TransactionResponse;
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

  @GetMapping("/deposit/detail")
  public ResponseEntity<DetailResponse> getAccount(
      HttpServletRequest request,
      @RequestBody Map<String, String> accountNum
  ) {
    return new ResponseEntity<>(accountService.getAccount(request, accountNum.get("account_num")),
        HttpStatus.OK);
  }

  @GetMapping("/deposit/transactions")
  public ResponseEntity<TransactionResponse> getTransactions(HttpServletRequest request,
      @RequestBody Map<String, String> searchTimestamp) {
    return new ResponseEntity<>(accountService.getTransactions(request, searchTimestamp.get("search_timestamp")), HttpStatus.OK);
  }
}
