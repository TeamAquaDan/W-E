package org.whalebank.backend.domain.dutchpay.dto.request;

import lombok.Getter;

@Getter
public class PaymentRequestDto {

  public int room_id;  // 방 아이디
  public int dutchpay_id;  // 더치페이 아이디

}
