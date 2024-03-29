package org.whalebank.backend.domain.negotiation.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NegoManageRequestDto {

  public int nego_id;
  public int result; // 1(승인), 2(거절)
  public String comment; // 승인/거절 사유

}
