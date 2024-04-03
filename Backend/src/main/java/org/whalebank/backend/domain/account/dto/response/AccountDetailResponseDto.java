package org.whalebank.backend.domain.account.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.global.openfeign.bank.response.AccountDetailResponse;

@Getter
@Setter
@Builder
public class AccountDetailResponseDto {

  public int account_id;
  public String account_name;
  public String account_num;
  public int balance_amt; // 현재잔액
  public int account_type; // 모임통장0 개인1
  public int day_limit_amt; // 1일 한도
  public int once_limit_amt; // 1회 한도
  public String issue_date; // 개설 일자

  public static AccountDetailResponseDto from(AccountDetailResponse resFromBank) {
    return AccountDetailResponseDto.builder()
        .account_id(resFromBank.getAccount_id())
        .account_name(resFromBank.getAccount_name())
        .account_num(resFromBank.getAccount_num())
        .account_type(resFromBank.getAccount_type())
        .balance_amt(resFromBank.getBalance_amt())
        .day_limit_amt(resFromBank.getDay_limit_amt())
        .once_limit_amt(resFromBank.getOnce_limit_amt())
        .issue_date(resFromBank.getIssue_date())
        .build();
  }

}
