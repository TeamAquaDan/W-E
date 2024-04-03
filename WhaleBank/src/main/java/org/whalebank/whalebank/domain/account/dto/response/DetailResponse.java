package org.whalebank.whalebank.domain.account.dto.response;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class DetailResponse {

  private int rsp_code; // 응답코드

  private String rsp_message; // 응답메세지

  private String account_num; // 계좌번호

  private int balance_amt;  // 조회 시점 계좌의 잔액

  private int withdrawable_amt; // 출금 가능액

  private int account_type; //   모임통장(0)/개인통장(1)

  private int account_id; // 계좌 고유 번호

  private String account_name;  // 계좌명

  private String issue_date;  // 개설일자

  private int day_limit_amt;  // 1일 한도

  private int once_limit_amt; // 1회 한도

}