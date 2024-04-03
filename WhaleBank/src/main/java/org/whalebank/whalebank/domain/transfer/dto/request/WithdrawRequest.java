package org.whalebank.whalebank.domain.transfer.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
public class WithdrawRequest {

  private int tran_amt;   // 거래 금액
  private LocalDateTime tran_dtm; // 요청일시

  private String account_password; // 출금계좌 비밀번호
  private String req_client_name; // 요청고객성명
  private String req_client_bank_code;    // 요청고객계좌 개설기관 표준코드
  private String req_client_account_num;  // 요청고객 계좌번호
  private String recv_client_name;    // 최종수취고객 성명
  private String recv_client_bank_code;   // 최종수취고객계좌 개설기관 표준코드
  private String recv_client_account_num; // 최종수취고객 계좌번호

  private String req_trans_memo;  // 내 계좌에 표시될 내역
}
