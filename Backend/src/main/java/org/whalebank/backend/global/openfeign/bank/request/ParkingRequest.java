package org.whalebank.backend.global.openfeign.bank.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ParkingRequest {

  public int account_id;
  public int parking_amt;

}
