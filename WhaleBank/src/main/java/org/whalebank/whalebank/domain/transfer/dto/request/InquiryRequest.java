package org.whalebank.whalebank.domain.transfer.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class InquiryRequest {

  private String bank_code_std;   // 입금은행 표준코드
  private int tran_amt;   // 거래금액
  private String account_num; // 계좌번호
  private String req_client_name; // 요청 고객 성명
  private String req_client_bank_code;    // 요청 고객 계좌 개설기관 표준코드
  private String req_client_account_num;  // 요청 고객 계좌번호
}
