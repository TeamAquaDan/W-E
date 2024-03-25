package org.whalebank.backend.domain.accountbook.service;

import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;
import org.whalebank.backend.domain.accountbook.dto.request.AccountBookEntryRequestDto;
import org.whalebank.backend.domain.accountbook.dto.response.AccountBookEntryResponse;
import org.whalebank.backend.domain.accountbook.dto.response.MonthlyHistoryResponseDto.AccountBookHistoryDetail;
import org.whalebank.backend.domain.accountbook.repository.AccountBookBulkRepository;
import org.whalebank.backend.domain.accountbook.repository.AccountBookRepository;
import org.whalebank.backend.domain.accountbook.dto.response.MonthlyHistoryResponseDto;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.BankAccessUtil;
import org.whalebank.backend.global.openfeign.bank.request.TransactionRequest;
import org.whalebank.backend.global.openfeign.bank.response.AccountListResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.AccountListResponseDto.AccountInfo;
import org.whalebank.backend.global.openfeign.bank.response.TransactionResponse;
import org.whalebank.backend.global.openfeign.card.CardAccessUtil;
import org.whalebank.backend.global.openfeign.card.response.CardHistoryResponse;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class AccountBookServiceImpl implements AccountBookService {

  private final AuthRepository userRepository;
  private final AccountBookRepository accountBookRepository;
  private final AccountBookBulkRepository bulkRepository;
  private final CardAccessUtil cardAccessUtil;
  private final BankAccessUtil bankAccessUtil;

  @Transactional
  @Override
  @Async
  public void saveAccountAndCardHistory(UserEntity user) {
    saveCardHistory(user);
    saveIncomeHistory(user);
  }

  private void saveCardHistory(UserEntity user) {
    // 카드 내역 조회
    CardHistoryResponse resFromCard = cardAccessUtil.getCardHistory(user.getCardAccessToken(),
        user.getLastCardHistoryFetchTime());
    // 카드 내역 저장
    List<AccountBookEntity> expensesList = resFromCard.getPay_list().stream()
        .map(detail -> AccountBookEntity.from(detail, user))
        .collect(Collectors.toList());

    bulkRepository.saveAll(expensesList);
  }

  private void saveIncomeHistory(UserEntity user) {
    List<AccountBookEntity> incomeList = new ArrayList<>();
    // 내 모든 계좌 불러오기
    AccountListResponseDto resFromBank = bankAccessUtil.getAccountInfo(
        user.getBankAccessToken());

    // 각 계좌의 거래내역 중 입금 내역만 불러옴
    for (AccountInfo accountInfo : resFromBank.getAccount_list()) {
      TransactionResponse bankHistory = bankAccessUtil.getTransactionHistory(
          user.getBankAccessToken(),
          TransactionRequest.of(accountInfo.account_id, user.getLastCardHistoryFetchTime()));

      incomeList.addAll(bankHistory.getTrans_list().stream()
          .filter(transaction -> transaction.getTrans_type() == 3) // 거래 유형이 입금인 것만 필터링
          .map(h -> AccountBookEntity.fromAccountHistory(h, user))
          .toList());
    }
    // 저장
    bulkRepository.saveAll(incomeList);
  }

  @Override
  public MonthlyHistoryResponseDto getIncomeAndExpenseHistory(String loginId, int year, int month) {
    UserEntity currentUser = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    if (month < 1 || month > 12) {
      throw new CustomException(ResponseCode.INVALID_TIME_FORMAT);
    }

    // 주어진 연도와 월로 YearMonth 객체 생성
    YearMonth yearMonth = YearMonth.of(year, month);
    // 해당 연도와 월의 마지막 날짜 얻기
    int lastDayOfMonth = yearMonth.lengthOfMonth();

    // 내 가계부 내역 중에 year, month에 해당하는 내역을 시간 내림차순으로 정렬해서 돌려줘야함
    List<AccountBookHistoryDetail> accountBookList = accountBookRepository.findAllByUserAndAccountBookDtmBetweenAndIsHideFalseOrderByAccountBookDtmDesc(
            currentUser,
            LocalDateTime.of(year, month, 1, 0, 0, 0),
            LocalDateTime.of(year, month, lastDayOfMonth, 23, 59, 59))
        .stream().map(AccountBookHistoryDetail::from)
        .toList();

    // 수입 및 지출 합산
    int incomeAmt = 0;
    int expenseAmt = 0;
    for (AccountBookHistoryDetail detail : accountBookList) {
      if (detail.getTrans_id() > 0) {
        expenseAmt += detail.getAccount_book_amt();
      } else {
        incomeAmt += detail.getAccount_book_amt();
      }
    }
    return MonthlyHistoryResponseDto.builder()
        .expense_amt(expenseAmt)
        .income_amt(incomeAmt)
        .account_book_list(accountBookList)
        .build();
  }

  @Override
  public void createAccountBookEntry(String loginId, AccountBookEntryRequestDto request) {

    UserEntity currentUser = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    AccountBookEntity accountBook = AccountBookEntity.createAccountBookEntry(currentUser, request);

    accountBookRepository.save(accountBook);

  }

  @Override
  public AccountBookEntryResponse getAccountBookEntry(int accountBookId, String loginId) {

    UserEntity currentUser = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    AccountBookEntity accountBook = accountBookRepository.getById(accountBookId);

    return AccountBookEntryResponse
        .builder()
        .account_book_id(accountBookId)
        .account_book_title(accountBook.getAccountBookTitle())
        .account_book_amt(accountBook.getAccountBookAmt())
        .account_book_dtm(accountBook.getAccountBookDtm().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")))
        .account_book_category(accountBook.getAccountBookCategory())
        .build();
  }
}
