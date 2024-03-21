package org.whalebank.backend.global.openfeign.bank.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ParkingBalanceResponse {

  public int rsp_code;
  public String rsp_message;
  public int parking_balance_amt;

}
