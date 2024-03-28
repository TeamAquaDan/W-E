package org.whalebank.backend.domain.accountbook.dto.request;

import lombok.Builder;
import lombok.Getter;
import org.whalebank.backend.domain.dutchpay.CategoryCalculateEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;

@Getter
@Builder
public class AccountBookEntryRequestDto {

  public String account_book_title; // 거래 제목
  public int account_amt; // 거래 금액
  public String account_book_date;  // 거래 일자 yyyy.MM.dd hh:mm
  public String account_book_category;  // 카테고리


  public static AccountBookEntryRequestDto create(int amount,
      CategoryCalculateEntity categoryCalculate,
      DutchpayRoomEntity dutchpayRoom) {
    return AccountBookEntryRequestDto
        .builder()
        .account_book_title(dutchpayRoom.getRoomName())
        .account_amt(amount)
        .account_book_date(String.valueOf(dutchpayRoom.getDutchpayDate().atStartOfDay()))
        .account_book_category(categoryCalculate.getCategory())
        .build();
  }
}
