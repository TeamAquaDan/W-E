package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.TransactionResponse;

public interface AccountService {

  AccountResponse getAccounts(HttpServletRequest request);

  DetailResponse getAccount(HttpServletRequest request, String accountNum);

  TransactionResponse getTransactions(HttpServletRequest request, String searchTimestamp);
}
