package org.whalebank.backend.global.openfeign.bank.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ParkingRequest {

  public int account_id;
  public int parking_amt;

}
