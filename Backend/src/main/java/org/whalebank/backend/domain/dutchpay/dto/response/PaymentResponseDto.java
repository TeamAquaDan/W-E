package org.whalebank.backend.domain.dutchpay.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
public class PaymentResponseDto {

  private int trans_id; // 거래 고유번호

  private String member_store_name; // 거래제목

  private int trans_amt;  // 거래 금액

  private String category;  // 카테고리

}
