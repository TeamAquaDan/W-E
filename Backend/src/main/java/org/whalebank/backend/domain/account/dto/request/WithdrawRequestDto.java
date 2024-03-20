package org.whalebank.backend.domain.account.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WithdrawRequestDto {

  public int tran_amt; // 거래 금액
  public int req_account_id; // 계좌 고유 번호
  public String req_account_num; // 요청 고객 계좌번호
  public String req_account_password; // 요청 고객 계좌 비밀번호
  public String recv_client_bank_code; // 최종수취고객 계좌 개설기관 표준코드
  public String recv_client_account_num; // 최종수최고객 계좌번호
  public String recv_client_name;
  public String req_trans_memo; // 내 거래내역에 표기할 메모
  public String recv_trans_memo; // 상대방 거래내역에 표기할 메모

}