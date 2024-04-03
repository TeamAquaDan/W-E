package org.whalebank.backend.global.openfeign.bank.response;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TransactionResponse {

  public int rsp_code;
  public String rsp_message;
  public int trans_cnt;
  public List<Transaction> trans_list;

  @Getter
  @Setter
  public static class Transaction {

    private LocalDateTime trans_dtm; // 거래일시
    private int trans_id; // 거래번호
    private int trans_type; // 거래유형 출금(2), 입금(3)
    private int trans_amt;  // 거래금액
    private int balance_amt;  // 거래 후 잔액
    private String trans_memo;  // 적요 (거래명, 거래 메모 등)
  }

}
