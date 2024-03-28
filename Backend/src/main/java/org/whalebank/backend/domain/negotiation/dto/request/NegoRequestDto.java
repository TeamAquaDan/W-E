package org.whalebank.backend.domain.negotiation.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NegoRequestDto {

  public int group_id;
  public int nego_amt;
  public String nego_reason; // 요청 사유

}
