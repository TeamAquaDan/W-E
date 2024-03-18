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
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.TransactionResponse;
import org.whalebank.whalebank.domain.account.repository.AccountRepository;
import org.whalebank.whalebank.domain.auth.repository.AuthRepository;
import org.whalebank.whalebank.domain.auth.security.TokenProvider;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class AccountServiceImpl implements AccountService {

  private final AuthRepository authRepository;
  private final TokenProvider tokenProvider;
  private final AccountRepository accountRepository;

  @Override
  public AccountResponse getAccounts(HttpServletRequest request) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    if (authRepository.findById(userId).get().getAccountList() == null) {
      return AccountResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌가 존재하지 않습니다")
          .build();
    }

    List<AccountEntity> findAccounts = authRepository.findById(userId).get().getAccountList();

    List<Account> accounts = findAccounts.stream()
        .map(a -> new Account(a.getAccountId(), a.getAccountType(), a.getAccountNum(),
            a.getAccountName()))
        .collect(Collectors.toList());

    return AccountResponse
        .builder()
        .rsp_code(200)
        .rsp_message("계좌 목록 조회 성공")
        .account_cnt(findAccounts.size())
        .account_list(accounts)
        .build();
  }

  public DetailResponse getAccount(HttpServletRequest request, String accountNum) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    AccountEntity account = accountRepository.findByAccountNum(accountNum);

    if (account == null) {
      return DetailResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌번호를 찾을 수 없습니다.")
          .build();
    }

    return DetailResponse
        .builder()
        .rsp_code(200)
        .rsp_message("계좌 조회 성공")
        .account_num(accountNum)
        .balance_amt(account.getBalanceAmt())
        .withdrawable_amt(account.getWithdrawableAmt())
        .account_type(account.getAccountType())
        .account_id(account.getAccountId())
        .account_name(account.getAccountName())
        .build();
  }

  public TransactionResponse getTransactions(HttpServletRequest request, String searchTimestamp){
    return null;
  }
}