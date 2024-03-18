package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;

public interface AccountService {

  AccountResponse getAccounts(HttpServletRequest request);

  DetailResponse getAccount(HttpServletRequest request, String accountNum);
}
