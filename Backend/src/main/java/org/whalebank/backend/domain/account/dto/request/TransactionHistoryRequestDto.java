package org.whalebank.backend.domain.account.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TransactionHistoryRequestDto {

  public int account_id;
  public String start_date; // yyyy-mm-dd
  public String end_date; // yyyy-mm-dd

}
