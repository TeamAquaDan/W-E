package org.whalebank.whalebank.domain.transfer.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@NoArgsConstructor
public class DepositRequest {

  private LocalDateTime trans_dtm;    // 요청일시

  private String bank_tran_id;    // 은행거래고유번호
  private String print_content;   // 입금계좌 인자내역
  private int trans_amt;  // 거래금액
  private String req_client_bank_code;    // 요청고객계좌 개설기관 표준코드
  private String req_client_account_num;  // 요청고객 계좌번호

}
