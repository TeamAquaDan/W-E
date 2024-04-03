package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.whalebank.whalebank.domain.account.dto.request.ParkingRequest;
import org.whalebank.whalebank.domain.account.dto.request.PasswordVerifyRequest;
import org.whalebank.whalebank.domain.account.dto.request.TransactionRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.ParkingResponse;
import org.whalebank.whalebank.domain.account.dto.response.PasswordVerifyResponse;
import org.whalebank.whalebank.domain.account.dto.response.TransactionResponse;

public interface AccountService {

  AccountResponse getAccounts(HttpServletRequest request);

  DetailResponse getAccount(HttpServletRequest request, int accountId);

  ParkingResponse depositParking(HttpServletRequest request, ParkingRequest parkingRequest);

  ParkingResponse withdrawParking(HttpServletRequest request, int accountId);

  ParkingResponse getParking(HttpServletRequest request, int accountId);

  TransactionResponse getTransactions(HttpServletRequest request, TransactionRequest transactionRequest);

  PasswordVerifyResponse verifyPassword(HttpServletRequest request, PasswordVerifyRequest passwordVerifyRequest);

  TransactionResponse getDepositList(HttpServletRequest request, LocalDateTime searchTimestamp);
}
