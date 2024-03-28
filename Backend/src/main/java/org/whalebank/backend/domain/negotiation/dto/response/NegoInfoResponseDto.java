package org.whalebank.backend.domain.negotiation.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.negotiation.NegotiationEntity;

@Getter
@Setter
@Builder
public class NegoInfoResponseDto {

  public int nego_amt; // 요청액
  public int current_amt; // 요청 당시 금액
  public String username; // 요청자 이름

  public static NegoInfoResponseDto of(NegotiationEntity entity, String childName) {
    return NegoInfoResponseDto.builder()
        .nego_amt(entity.getNegoAmt())
        .current_amt(entity.getCurrentAllowanceAmt())
        .username(childName)
        .build();
  }

}
