package org.whalebank.whalebank.domain.account.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Service;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.account.dto.request.ParkingRequest;
import org.whalebank.whalebank.domain.account.dto.request.PasswordVerifyRequest;
import org.whalebank.whalebank.domain.account.dto.request.TransactionRequest;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse.Account;
import org.whalebank.whalebank.domain.account.dto.response.DetailResponse;
import org.whalebank.whalebank.domain.account.dto.response.ParkingResponse;
import org.whalebank.whalebank.domain.account.dto.response.PasswordVerifyResponse;
import org.whalebank.whalebank.domain.account.dto.response.TransactionResponse;
import org.whalebank.whalebank.domain.account.repository.AccountRepository;
import org.whalebank.whalebank.domain.auth.AuthEntity;
import org.whalebank.whalebank.domain.auth.repository.AuthRepository;
import org.whalebank.whalebank.domain.auth.security.TokenProvider;
import org.whalebank.whalebank.domain.transfer.TransferEntity;
import org.whalebank.whalebank.domain.transfer.repository.TransferRepository;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class AccountServiceImpl implements AccountService {

  private final AuthRepository authRepository;
  private final TokenProvider tokenProvider;
  private final AccountRepository accountRepository;
  private final TransferRepository transferRepository;

  @Override
  public AccountResponse getAccounts(HttpServletRequest request) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    if (authRepository.findById(userId).get().getAccountList().isEmpty()) {
      return AccountResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌가 존재하지 않습니다")
          .build();
    }

    List<AccountEntity> findAccounts = authRepository.findById(userId).get().getAccountList();

    List<Account> accounts = findAccounts.stream()
        .map(a -> new Account(a.getAccountId(), a.getAccountType(), a.getAccountNum(),
            a.getAccountName(), a.getBalanceAmt()))
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

    Optional<AccountEntity> account = accountRepository.findById(String.valueOf(accountId));

    if (account.isEmpty()) {
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
        .account_num(account.get().getAccountNum())
        .balance_amt(account.get().getBalanceAmt())
        .withdrawable_amt(account.get().getWithdrawableAmt())
        .account_type(account.get().getAccountType())
        .account_id(account.get().getAccountId())
        .account_name(account.get().getAccountName())
        .issue_date(account.get().getIssueDate().format(DateTimeFormatter.ofPattern("yyyyDDmm")))
        .day_limit_amt(account.get().getDayLimitAmt())
        .once_limit_amt(account.get().getOnceLimitAmt())
        .build();
  }

  @Override
  public ParkingResponse depositParking(HttpServletRequest request, ParkingRequest parkingRequest) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    int accountId = parkingRequest.getAccount_id();
    int depositAmt = parkingRequest.getParking_amt();

    Optional<AccountEntity> account = accountRepository.findById(String.valueOf(accountId));

    if (account.isEmpty()) {
      return ParkingResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌를 찾을 수 없습니다.")
          .build();
    }

    if (account.get().getBalanceAmt() < depositAmt) {
      return ParkingResponse
          .builder()
          .rsp_code(402)
          .rsp_message("계좌의 잔액이 부족합니다.")
          .build();
    } else {
      account.get().depositParking(depositAmt);
    }

    TransferEntity transfer = TransferEntity.createTransfer(parkingRequest,
        account.get());

    transferRepository.save(transfer);

    account.get().addTransfer(transfer);

    return ParkingResponse
        .builder()
        .rsp_code(200)
        .rsp_message("파킹통장에 저금이 되었습니다.")
        .parking_balance_amt(account.get().getParkingBalanceAmt())
        .build();
  }

  @Override
  public ParkingResponse withdrawParking(HttpServletRequest request,
      int accountId) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    Optional<AccountEntity> account = accountRepository.findById(String.valueOf(accountId));

    if (account.isEmpty()) {
      return ParkingResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌를 찾을 수 없습니다.")
          .build();
    }

    TransferEntity transfer = TransferEntity.createTransfer(account.get().getParkingBalanceAmt(),
        account.get());

    transferRepository.save(transfer);

    account.get().addTransfer(transfer);

    // 금액 전액 출금
    account.get().withdrawParking();

    return ParkingResponse
        .builder()
        .rsp_code(200)
        .rsp_message("파킹통장 잔액이 전액 출금 되었습니다.")
        .parking_balance_amt(account.get().getParkingBalanceAmt())
        .build();
  }

  @Override
  public ParkingResponse getParking(HttpServletRequest request, int accountId) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    Optional<AccountEntity> account = accountRepository.findById(String.valueOf(accountId));

    if (account.isEmpty()) {
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
        .parking_balance_amt(account.get().getParkingBalanceAmt())
        .build();
  }

  @Override
  public TransactionResponse getTransactions(HttpServletRequest request,
      TransactionRequest transactionRequest) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    int accountId = transactionRequest.getAccount_id();
    LocalDate fromDate = transactionRequest.getFrom_date();
    LocalDate toDate = transactionRequest.getTo_date().plusDays(1);

    if (accountRepository.findById(String.valueOf(accountId)).isEmpty()) {
      return TransactionResponse
          .builder()
          .rsp_code(404)
          .rsp_message("계좌가 존재하지 않습니다")
          .build();
    }

    List<TransferEntity> findTransactions = accountRepository.findById(String.valueOf(accountId))
        .get().getTransferList();

    List<TransactionResponse.Transaction> transactions = findTransactions.stream()
        .filter(t -> t.getTransDtm().isAfter(fromDate.atStartOfDay()) && t.getTransDtm()
            .isBefore(toDate.atStartOfDay()))
        .map(t -> new TransactionResponse.Transaction(t.getTransDtm(), t.getTransId(),
            t.getTransType(), t.getTransAmt(), t.getBalanceAmt(), t.getTransMemo())).sorted()
        .collect(Collectors.toList());

    return TransactionResponse
        .builder()
        .rsp_code(200)
        .rsp_message("거래내역이 조회되었습니다.")
        .trans_cnt(transactions.size())
        .trans_list(transactions)
        .build();
  }

  @Override
  public PasswordVerifyResponse verifyPassword(HttpServletRequest request,
      PasswordVerifyRequest passwordVerifyRequest) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    AccountEntity account = accountRepository.findById(
        String.valueOf(passwordVerifyRequest.getAccount_id())).get();

    if (!account.getAccountPassword().equals(passwordVerifyRequest.getAccount_password())) {
      return PasswordVerifyResponse
          .builder()
          .rsp_code(401)
          .rsp_message("계좌 비밀번호가 틀렸습니다")
          .build();
    }

    return PasswordVerifyResponse
        .builder()
        .rsp_code(200)
        .rsp_message("계좌 비밀번호가 맞습니다")
        .build();
  }

  @Override
  public TransactionResponse getDepositList(HttpServletRequest request,
      LocalDateTime searchTimestamp) {
    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    List<AccountEntity> accountList = authRepository.findById(userId).get().getAccountList();

    List<TransactionResponse.Transaction> transactions = new ArrayList<>();

    for (AccountEntity account : accountList) {
      List<TransferEntity> depositList = account.getTransferList();

      List<TransactionResponse.Transaction> transactionList = depositList.stream()
          .filter(t -> t.getTransDtm().isAfter(searchTimestamp) && t.getTransType() == 3)
          .map(t -> new TransactionResponse.Transaction(t.getTransDtm(), t.getTransId(),
              t.getTransType(), t.getTransAmt(), t.getBalanceAmt(), t.getTransMemo())).sorted()
          .toList();

      transactions.addAll(transactionList);

    }

    return TransactionResponse
        .builder()
        .rsp_code(200)
        .rsp_message("입금내역이 조회되었습니다.")
        .trans_cnt(transactions.size())
        .trans_list(transactions)
        .build();
  }

  @Scheduled(cron = "0 0 0 * * *")
  public void resetWithdrawableAmt() {
    // 매일 00시 출금 가능액을 1일 한도액으로 리셋
    for (AccountEntity account : accountRepository.findAll()) {
      account.resetWithdrawableAmt();
    }
  }
}