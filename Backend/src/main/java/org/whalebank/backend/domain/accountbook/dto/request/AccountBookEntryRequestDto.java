package org.whalebank.backend.domain.accountbook.dto.request;

import lombok.Getter;

@Getter
public class AccountBookEntryRequestDto {

  public String account_book_title; // 거래 제목
  public int account_amt; // 거래 금액
  public String account_book_date;  // 거래 일자 yyyy.MM.dd hh:mm
  public String account_book_category;  // 카테고리

}
