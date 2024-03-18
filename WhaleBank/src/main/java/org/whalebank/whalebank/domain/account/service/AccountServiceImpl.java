package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse.Account;
import org.whalebank.whalebank.domain.account.repository.AccountRespository;
import org.whalebank.whalebank.domain.auth.repository.AuthRepository;
import org.whalebank.whalebank.domain.auth.security.TokenProvider;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class AccountServiceImpl implements AccountService {

  private final AuthRepository authRepository;
  private final TokenProvider tokenProvider;

  @Override
  public AccountResponse getAccounts(HttpServletRequest request) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    List<AccountEntity> findAccounts = authRepository.findById(userId).get().getAccountList();

    List<Account> accounts = findAccounts.stream()
        .map(a -> new Account(a.getAccountId(), a.getAccountNum(), a.getAccountName()))
        .collect(Collectors.toList());

    return AccountResponse
        .builder()
        .account_cnt(findAccounts.size())
        .account_list(accounts)
        .build();
  }
}
