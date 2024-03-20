package org.whalecard.whalecard.domain.card.dto.response;

import java.time.LocalDate;
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
public class DetailResponse {

  private int rsp_code; // 응답코드
  private String rsp_message; // 응답메세지

  private int card_id;  // 카드아이디
  private String card_no;  // 카드번호
  private String card_name; // 카드 상품명
  private String account_num; // 결제 계좌번호
  private LocalDate issue_date;  // 카드 발급일자
  private LocalDate end_date;  // 카드 만료일자

}
