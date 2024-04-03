package org.whalebank.backend.domain.accountbook.dto.response;

import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;

@Getter
@Setter
@Builder
public class AccountBookEntryResponseDto {

  private int account_book_id;  // 수입/지출 내역 아이디
  private int trans_id; // 거래 고유 번호
  private String account_book_title;  // 거래 제목
  private int account_book_amt; // 거래 금액
  private String account_book_dtm;  // 거래 일시 yyyy.MM.dd HH:mm
  private String account_book_category; // 카테고리

  public static AccountBookEntryResponseDto from(AccountBookEntity accountBook) {
    return AccountBookEntryResponseDto
        .builder()
        .account_book_id(accountBook.getAccountBookId())
        .account_book_title(accountBook.getAccountBookTitle())
        .account_book_amt(accountBook.getAccountBookAmt())
        .account_book_dtm(
            accountBook.getAccountBookDtm().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")))
        .account_book_category(accountBook.getAccountBookCategory())
        .build();
  }
}
