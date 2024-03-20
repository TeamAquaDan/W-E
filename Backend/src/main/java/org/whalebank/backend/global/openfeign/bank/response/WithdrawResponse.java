package org.whalebank.backend.global.openfeign.bank.response;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WithdrawResponse {

  public String rsp_code;
  public String rsp_message;
  public int api_tran_id; // 거래 고유 번호
  public LocalDateTime api_tran_dtm; // 거래일시
  public String dps_bank_code_std; // 입금기관 표준 코드
  public String dps_bank_name; // 입금기관명
  public String dps_account_num_masked; // 입금 계좌번호
  public String dps_account_holder_name; // 수취인 성명
  public String account_holder_name; // 송금인 성명
  public int tran_amt; // 거래 금액
  public int wd_limit_remain_amt; // 출금한도 잔여 금액
  public int balance_amt; // 거래 후 잔액
  public String trans_memo; // 적요


}
