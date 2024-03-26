package org.whalebank.backend.domain.allowance.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateAllowanceRequestDto {

  public int group_id;
  public Boolean is_monthly;
  public int allowance_amt;
  public int payment_date;

}
