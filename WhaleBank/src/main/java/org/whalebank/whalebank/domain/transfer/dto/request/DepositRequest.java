package org.whalebank.whalebank.domain.transfer.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@NoArgsConstructor
public class DepositRequest {

  private LocalDateTime trans_dtm;    // 요청일시

  private int trans_amt;  // 거래금액
  private String req_client_name; // 요청고객명
  private String req_client_bank_code;    // 요청고객계좌 개설기관 표준코드
  private String req_client_account_num;  // 요청고객 계좌번호

  private String recv_client_bank_code;   // 최종수취고객계좌 개설기관 표준코드
  private String recv_client_account_num; // 최종수취고객 계좌번호
  private String recv_client_name;  // 최종수취고객명

  private String recv_trans_memo; // 받는 계좌 표시 내역
}
