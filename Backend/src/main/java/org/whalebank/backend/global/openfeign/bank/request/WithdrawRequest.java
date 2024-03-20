package org.whalebank.backend.global.openfeign.bank.request;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WithdrawRequest {

  public int tran_amt;
  public LocalDateTime tran_dtm; // 요청 일시
  public String req_client_name; // 요청 고객 성명
  public String req_client_bank_code; // 요청고객 계좌번호",
  public String recv_client_name; //최종수취고객성명
  public String recv_client_bank_code; // 최종수취고객계좌 개설기관 표준코드",
  public String recv_client_account_num; // 최종수취고객 계좌번호",
  public String req_trans_memo; // 내 거래내역에 표기할 메모",
  public String account_password; //요청 계좌 비밀번호"

}
