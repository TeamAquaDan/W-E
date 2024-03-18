package org.whalebank.whalebank.domain.account.dto.response;

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
public class ParkingResponse {

  private int rsp_code;
  private String rsp_message;
  private int parking_balance_amt;  // 파킹통장 잔액

}
