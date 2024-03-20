package org.whalebank.backend.domain.account.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.global.openfeign.bank.response.AccountListResponseDto.AccountInfo;

@Getter
@Setter
@Builder
public class AccountInfoResponseDto {

  public int account_id; // 계좌 고유번호
  public String account_name; // 계좌명
  public String account_num; // 계좌번호
  public int balance_amt; // 현재잔액
  public int account_type; // 계좌 구분

  public static AccountInfoResponseDto from(AccountInfo accountInfo) {
    return AccountInfoResponseDto.builder()
        .account_id(accountInfo.getAccount_id())
        .account_name(accountInfo.getAccount_name())
        .account_num(accountInfo.getAccount_num())
        .account_type(accountInfo.getAccount_type())
        .balance_amt(accountInfo.getBalance_amt())
        .build();
  }

}
