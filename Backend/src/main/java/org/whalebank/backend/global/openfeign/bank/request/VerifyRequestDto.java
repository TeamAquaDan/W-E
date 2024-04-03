package org.whalebank.backend.global.openfeign.bank.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class VerifyRequestDto {

  public int account_id;
  public String account_password;

  public static VerifyRequestDto of(int account_id, String account_password) {
    return VerifyRequestDto.builder()
        .account_id(account_id)
        .account_password(account_password)
        .build();
  }

}
