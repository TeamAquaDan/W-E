package org.whalebank.backend.domain.accountbook.dto.response;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;

@Getter
@Setter
@Builder
public class CardHistoryResponseDto {

  public int account_book_id; // 가계부 내역아이디
  public int trans_id; // 거래 고유 번호
  public String account_book_title; // 거래 제목
  public int account_book_amt; // 거래금액
  public String account_book_dtm; // 거래일시 yyyy.mm.dd hh:mm:ss
  public String account_book_category; // 카테고리

  public static CardHistoryResponseDto from(AccountBookEntity entity) {
    return CardHistoryResponseDto.builder()
        .account_book_id(entity.getAccountBookId())
        .trans_id(entity.getTransId())
        .account_book_title(entity.getAccountBookTitle())
        .account_book_amt(entity.getAccountBookAmt())
        .account_book_dtm(entity.getAccountBookDtm().format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm:ss")))
        .account_book_category(entity.getAccountBookCategory())
        .build();
  }


}
