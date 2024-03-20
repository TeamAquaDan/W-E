package org.whalebank.backend.global.openfeign.bank.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class AccountIdRequestDto {

  public int account_id; // 계좌 고유 번호

}
