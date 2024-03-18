package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import org.whalebank.whalebank.domain.account.dto.request.ParkingRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.ParkingResponse;
import org.whalebank.whalebank.domain.account.dto.response.TransactionResponse;

public interface AccountService {

  AccountResponse getAccounts(HttpServletRequest request);

  DetailResponse getAccount(HttpServletRequest request, int accountId);

  ParkingResponse depositParking(HttpServletRequest request, ParkingRequest parkingRequest);

  ParkingResponse withdrawParking(HttpServletRequest request, int accountId);

  ParkingResponse getParking(HttpServletRequest request, int accountId);

  TransactionResponse getTransactions(HttpServletRequest request, String searchTimestamp);
}
