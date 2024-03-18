package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;

public interface AccountService {

  AccountResponse getAccounts(HttpServletRequest request);
}
