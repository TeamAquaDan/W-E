package org.whalebank.backend.global.openfeign.bank.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AccountDetailResponse {

  public String rsp_code;
  public String rsp_message;
  public String account_num; // 계좌번호
  public int balance_amt; // 조회시점 계좌의 잔액
  public int withdrawable_amt; // 출금 가능액
  public int account_type; // 모임통장(0), 개인통장(1)
  public int account_id; // 계좌 고유번호
  public String account_name; // 계좌명
  public int parking_balance_amt; // 파킹통장 잔액
  public String issue_date; // 개설일자
  public int day_limit_amt;  // 1일 한도
  public int once_limit_amt; // 1회 한도

}
