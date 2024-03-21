package org.whalecard.whalecard.domain.transaction.dto.response;

import java.time.LocalDateTime;
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

  private int rsp_code; // 응답코드
  private String rsp_message; // 응답메세지

  private int pay_cnt;

  private List<Transaction> pay_list;

  @NoArgsConstructor
  @AllArgsConstructor
  @Getter
  @Setter
  public static class Transaction implements Comparable<Transaction>{

    private int trans_id;  // 거래 고유 번호
    private String card_no;  // 카드번호
    private String card_name; // 카드 상품명
    private int trans_amt;  // 이용금액
    private String member_store_name; // 가맹점명
    private String member_store_type; // 가맹점 업종
    private LocalDateTime transaction_dtm;  // 결제일시


    @Override
    public int compareTo(Transaction t) {
      return t.transaction_dtm.compareTo(transaction_dtm);
    }

  }

}
