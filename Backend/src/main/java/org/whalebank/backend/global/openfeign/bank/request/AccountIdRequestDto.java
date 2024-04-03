package org.whalebank.backend.global.openfeign.bank.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class AccountIdRequestDto {

  public int account_id; // 계좌 고유 번호

  public static AccountIdRequestDto create(int accountId) {
    return AccountIdRequestDto.builder().account_id(accountId).build();
  }
}
