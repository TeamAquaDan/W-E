package org.whalebank.whalebank.domain.account.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ParkingRequest {

  private int account_id;
  private int parking_amt;

}
