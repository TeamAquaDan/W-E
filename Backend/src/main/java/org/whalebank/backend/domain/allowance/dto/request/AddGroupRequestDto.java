package org.whalebank.backend.domain.allowance.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AddGroupRequestDto {

  public int user_id;
  public String group_nickname;
  public Boolean is_monthly;
  public int allowance_amt; // 용돈금액
  public int payment_date; // 용돈 지급일 1~28일 또는 1(월)~7(일요일)
  public int account_id;    // 출금 계좌 고유번호
  public String account_num;// 출금 계좌 계좌번호
  public String account_password; // 출금 계좌 비밀번호

}
