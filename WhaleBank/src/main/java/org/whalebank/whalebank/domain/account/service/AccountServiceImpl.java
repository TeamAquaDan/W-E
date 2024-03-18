package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.account.dto.request.ParkingRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse.Account;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.ParkingResponse;
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

  @Override
  public DetailResponse getAccount(HttpServletRequest request, int accountId) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    AccountEntity account = accountRepository.findByAccountId(accountId);

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
        .account_num(account.getAccountNum())
        .balance_amt(account.getBalanceAmt())
        .withdrawable_amt(account.getWithdrawableAmt())
        .account_type(account.getAccountType())
        .account_id(account.getAccountId())
        .account_name(account.getAccountName())
        .build();
  }

  @Override
  public ParkingResponse depositParking(HttpServletRequest request, ParkingRequest parkingRequest) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    int accountId = parkingRequest.getAccount_id();
    int depositAmt = parkingRequest.getParking_amt();

    AccountEntity account = accountRepository.findByAccountId(accountId);

    if (account == null) {
      return ParkingResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌를 찾을 수 없습니다.")
          .build();
    }

    if (account.getBalanceAmt() < depositAmt) {
      return ParkingResponse
          .builder()
          .rsp_code(402)
          .rsp_message("계좌의 잔액이 부족합니다.")
          .build();
    } else {
      account.depositParking(depositAmt);
    }

    return ParkingResponse
        .builder()
        .rsp_code(200)
        .rsp_message("파킹통장에 저금이 되었습니다.")
        .parking_balance_amt(account.getParkingBalanceAmt())
        .build();
  }

  @Override
  public ParkingResponse withdrawParking(HttpServletRequest request,
      int accountId) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    AccountEntity account = accountRepository.findByAccountId(accountId);

    if (account == null) {
      return ParkingResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌를 찾을 수 없습니다.")
          .build();
    }

    account.withdrawParking();

    return ParkingResponse
        .builder()
        .rsp_code(200)
        .rsp_message("파킹통장 잔액이 전액 출금 되었습니다.")
        .parking_balance_amt(account.getParkingBalanceAmt())
        .build();
  }

  @Override
  public ParkingResponse getParking(HttpServletRequest request, int accountId) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    AccountEntity account = accountRepository.findByAccountId(accountId);

    if (account == null) {
      return ParkingResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌를 찾을 수 없습니다.")
          .build();
    }

    return ParkingResponse
        .builder()
        .rsp_code(200)
        .rsp_message("파킹통장 잔액이 조회되었습니다.")
        .parking_balance_amt(account.getParkingBalanceAmt())
        .build();
  }

  @Override
  public TransactionResponse getTransactions(HttpServletRequest request, String searchTimestamp) {
    return null;
  }
}