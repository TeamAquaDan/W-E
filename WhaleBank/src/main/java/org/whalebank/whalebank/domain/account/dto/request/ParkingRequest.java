package org.whalebank.whalebank.domain.account.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ParkingRequest {

  public int account_id;
  public int parking_amt;

}
