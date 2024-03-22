package org.whalebank.backend.global.openfeign.card.response;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CardHistoryResponse {

  public int rsp_code;
  public String rsp_msg;
  public int pay_cnt;
  public List<CardHistoryDetail> pay_list;

  @Getter
  @Setter
  public static class CardHistoryDetail {
    public int trans_id;  // 거래 고유 번호
    public String card_no;  // 카드번호
    public String card_name; // 카드 상품명
    public int trans_amt;  // 이용금액
    public String member_store_name; // 가맹점명
    public String member_store_type; // 가맹점 업종
    public LocalDateTime transaction_dtm;  // 결제일시
  }

}
