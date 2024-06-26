package org.whalebank.backend.global.openfeign.bank.response;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DepositResponse {

  private int rsp_code;
  private String rsp_message;

  private int api_tran_id; // 거래고유번호
  private LocalDateTime api_tran_dtm; // 거래일시
  private String wd_bank_code_std; // 출금기관 표준코드
  private String wd_bank_name; // 출금기관명
  private String wd_account_num_masked; // 출금계좌번호
  private String wd_account_holder_name;    // 송금인성명

  private LocalDate bank_tran_date; // 거래일자
  private String account_name;    // 계좌명
  private String bank_code_std;   // 입금기관 표준코드
  private String bank_name;   // 은행명
  private String account_num_masked;  // 입금계좌번호
  private String account_holder_name; // 수취인성명
  private int tran_amt;   // 거래금액

  private int balance_amt;    // 거래 후 잔액
  private String trans_memo;  // 적요

}
