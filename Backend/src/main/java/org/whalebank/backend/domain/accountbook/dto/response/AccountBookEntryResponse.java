package org.whalebank.backend.domain.accountbook.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class AccountBookEntryResponse {

  private int account_book_id;  // 수입/지출 내역 아이디
  private int trans_id; // 거래 고유 번호
  private String account_book_title;  // 거래 제목
  private int account_book_amt; // 거래 금액
  private String account_book_dtm;  // 거래 일시 yyyy.MM.dd HH:mm
  private String account_book_category; // 카테고리

}
