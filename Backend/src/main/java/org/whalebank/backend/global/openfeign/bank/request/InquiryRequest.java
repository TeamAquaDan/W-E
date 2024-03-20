package org.whalebank.backend.global.openfeign.bank.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.account.dto.request.InquiryRequestDto;

@Getter
@Setter
@Builder
public class InquiryRequest {

  private String bank_code_std;   // 입금은행 표준코드
  private String account_num; // 계좌번호

  private int tran_amt;   // 거래금액
  private String req_client_name; // 요청 고객 성명
  private String req_client_bank_code;    // 요청 고객 계좌 개설기관 표준코드
  private String req_client_account_num;  // 요청 고객 계좌번호

  public static InquiryRequest from(InquiryRequestDto requestDto) {
    return InquiryRequest.builder()
        .bank_code_std(requestDto.getBank_code_std())
        .account_num(requestDto.getAccount_num())
        .tran_amt(0)
        .req_client_name(null)
        .req_client_bank_code("103")
        .req_client_account_num(null)
        .build();
  }

}
