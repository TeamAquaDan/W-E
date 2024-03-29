package org.whalebank.whalebank.domain.account.dto.request;

import lombok.Getter;

@Getter
public class PasswordVerifyRequest {
  
  public int account_id;  // 계좌 고유번호
  public String account_password; // 계좌 비밀번호

}
