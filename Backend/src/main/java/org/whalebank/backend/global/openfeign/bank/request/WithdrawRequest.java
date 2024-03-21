package org.whalebank.backend.global.openfeign.bank.request;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;

@Getter
@Setter
@Builder
public class WithdrawRequest {

  public int tran_amt; // 거래금액
  public LocalDateTime tran_dtm; // 요청 일시

  public String account_password; //요청 계좌 비밀번호"
  public String req_client_name; // 요청 고객 성명
  public String req_client_bank_code; // 요청고객 개설기관 표준코드,
  public String req_client_account_num; // 요청고객 게좌번호
  public String recv_client_name; //최종수취고객성명
  public String recv_client_bank_code; // 최종수취고객계좌 개설기관 표준코드",
  public String recv_client_account_num; // 최종수취고객 계좌번호",
  public String req_trans_memo; // 내 거래내역에 표기할 메모",

  public static WithdrawRequest of(String reqUsername, WithdrawRequestDto reqDto) {
    return WithdrawRequest.builder()
        .tran_amt(reqDto.getTran_amt())
        .tran_dtm(LocalDateTime.now())
        .account_password(reqDto.getReq_account_password())
        .recv_client_name(reqUsername)
        .req_client_bank_code("103")
        .req_client_account_num(reqDto.getReq_account_num())
        .recv_client_name(reqDto.getRecv_client_name())
        .recv_client_bank_code(reqDto.getRecv_client_bank_code())
        .recv_client_account_num(reqDto.getRecv_client_account_num())
        .req_trans_memo(reqDto.getReq_trans_memo())
        .build();
  }

}
