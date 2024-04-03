package org.whalebank.whalebank.domain.account.controller;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.whalebank.domain.account.dto.request.ParkingRequest;
import org.whalebank.whalebank.domain.account.dto.request.PasswordVerifyRequest;
import org.whalebank.whalebank.domain.account.dto.request.TransactionRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.ParkingResponse;
import org.whalebank.whalebank.domain.account.dto.response.PasswordVerifyResponse;
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

  @PostMapping("/deposit/detail")
  public ResponseEntity<DetailResponse> getAccount(
      HttpServletRequest request,
      @RequestBody Map<String, Integer> accountId
  ) {
    return new ResponseEntity<>(accountService.getAccount(request, accountId.get("account_id")),
        HttpStatus.OK);
  }

  @PatchMapping("/parking/deposit")
  public ResponseEntity<ParkingResponse> depositParking(HttpServletRequest request,
      @RequestBody ParkingRequest parkingRequest) {
    return new ResponseEntity<>(accountService.depositParking(request, parkingRequest),
        HttpStatus.OK);
  }


  @PatchMapping("/parking/withdraw")
  public ResponseEntity<ParkingResponse> withdrawParking(HttpServletRequest request,
      @RequestBody Map<String, Integer> accountId) {
    return new ResponseEntity<>(
        accountService.withdrawParking(request, accountId.get("account_id")),
        HttpStatus.OK);
  }

  @PostMapping("/parking")
  public ResponseEntity<ParkingResponse> getParking(HttpServletRequest request,
      @RequestBody Map<String, Integer> parkingRequest) {
    return new ResponseEntity<>(
        accountService.getParking(request, parkingRequest.get("account_id")),
        HttpStatus.OK);
  }

  @PostMapping("/deposit/transactions")
  public ResponseEntity<TransactionResponse> getTransactions(HttpServletRequest request,
      @RequestBody TransactionRequest transactionRequest) {
    return new ResponseEntity<>(
        accountService.getTransactions(request, transactionRequest),
        HttpStatus.OK);
  }

  @PostMapping("/deposit/list")
  public ResponseEntity<TransactionResponse> getDepositList(HttpServletRequest request,
      @RequestBody Map<String, LocalDateTime> timestamp) {

    return new ResponseEntity<>(
        accountService.getDepositList(request, timestamp.get("search_timestamp")), HttpStatus.OK);
  }

  @PostMapping("/password-verify")
  public ResponseEntity<PasswordVerifyResponse> verifyPassword(HttpServletRequest request,
      @RequestBody PasswordVerifyRequest passwordVerifyRequest) {
    return new ResponseEntity<>(
        accountService.verifyPassword(request, passwordVerifyRequest), HttpStatus.OK);
  }
}
