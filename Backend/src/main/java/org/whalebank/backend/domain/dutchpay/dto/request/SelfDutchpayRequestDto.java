package org.whalebank.backend.domain.dutchpay.dto.request;

import lombok.Getter;

@Getter
public class SelfDutchpayRequestDto {

  public String account_num;  // 출금 계좌번호
  public String account_password; // 출금 계좌 비밀번호

}
