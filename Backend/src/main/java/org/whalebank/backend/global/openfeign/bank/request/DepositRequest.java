package org.whalebank.backend.global.openfeign.bank.request;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class DepositRequest {

  public LocalDateTime tran_dtm; // 요청 일시
  public int tran_amt; // 거래금액

  public String req_client_name; // 요청 고객 성명
  public String req_client_bank_code; // 요청고객 개설기관 표준코드,
  public String req_client_account_num; // 요청고객 게좌번호
  public String recv_client_bank_code; // 최종수취고객계좌 개설기관 표준코드",
  public String recv_client_account_num; // 최종수취고객 계좌번호",
  public String recv_client_name; //최종수취고객성명
  public String recv_trans_memo; // 수취인 거래내역에 표기할 메모",

}
