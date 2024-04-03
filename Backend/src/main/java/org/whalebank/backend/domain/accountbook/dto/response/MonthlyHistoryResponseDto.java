package org.whalebank.backend.domain.accountbook.dto.response;

import java.time.format.DateTimeFormatter;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;

@Getter
@Setter
@Builder
public class MonthlyHistoryResponseDto {

  int income_amt;
  int expense_amt;
  List<AccountBookHistoryDetail> account_book_list;

  @Getter
  @Setter
  @Builder
  public static class AccountBookHistoryDetail {
    public int account_book_id; // 가계부 내역아이디
    public int trans_id; // 거래 고유 번호
    public String account_book_title; // 거래 제목
    public int account_book_amt; // 거래금액
    public String account_book_dtm; // 거래일시 yyyy.mm.dd hh:mm
    public String account_book_category; // 카테고리

    public static AccountBookHistoryDetail from(AccountBookEntity entity) {
      return AccountBookHistoryDetail.builder()
          .account_book_id(entity.getAccountBookId())
          .trans_id(entity.getTransId())
          .account_book_title(entity.getAccountBookTitle())
          .account_book_amt(entity.getAccountBookAmt())
          .account_book_dtm(entity.getAccountBookDtm().format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm")))
          .account_book_category(entity.getAccountBookCategory())
          .build();
    }
  }

  public static MonthlyHistoryResponseDto from(int incomeAmt, int expenseAmt,
      List<AccountBookHistoryDetail> accountBookList) {
    return MonthlyHistoryResponseDto.builder()
        .income_amt(incomeAmt)
        .expense_amt(expenseAmt)
        .account_book_list(accountBookList)
        .build();
  }

}
