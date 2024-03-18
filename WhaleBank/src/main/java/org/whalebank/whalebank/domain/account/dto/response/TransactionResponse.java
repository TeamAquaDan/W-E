package org.whalebank.whalebank.domain.account.dto.response;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class TransactionResponse {

  private int trans_cnt;  // 거래 내역 수

  private List<Transaction> trans_list;

  @NoArgsConstructor
  @AllArgsConstructor
  @Getter
  @Setter
  public static class Transaction {

    private String trans_dtime; // 거래일시
    private int trans_no; // 거래번호
    private int trans_type; // 거래유형 출금(2), 입금(3)
    private int trans_amt;  // 거래금액
    private int balance_amt;  // 거래 후 잔액
    private String trans_memo;  // 적요 (거래명, 거래 메모 등)

  }

}
