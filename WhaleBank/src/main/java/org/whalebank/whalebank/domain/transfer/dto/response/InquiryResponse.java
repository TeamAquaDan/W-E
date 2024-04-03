package org.whalebank.whalebank.domain.transfer.dto.response;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InquiryResponse {

  private int rsp_code;
  private String rsp_message;

  private LocalDateTime api_tran_dtm;  // 거래일시
  private String req_client_name; // 요청 고객 성명
  private String bank_code_std;    // 입금기관 표준코드
  private String bank_name;    // 입금기관명
  private String account_num;  // 입금계좌번호
  private String account_holder_name;  // 수취인성명
  private String wd_bank_name; // 출금기관명
  private String wd_account_num;   // 출금 계좌번호
  private int tran_amt;    // 거래금액

}
