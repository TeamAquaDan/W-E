package org.whalebank.whalebank.domain.account.dto.request;

import java.time.LocalDate;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class TransactionRequest {

  private int account_id; // 계좌고유번호
  private LocalDate from_date;  // 조회 시작일자
  private LocalDate to_date;  // 조회 종료일자

}
