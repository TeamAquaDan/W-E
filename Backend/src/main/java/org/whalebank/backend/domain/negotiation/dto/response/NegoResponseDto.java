package org.whalebank.backend.domain.negotiation.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class NegoResponseDto {

  public int nego_amt;
  public String user_name;

  public static NegoResponseDto of(int nego_amt, String user_name) {
    return NegoResponseDto.builder()
        .nego_amt(nego_amt)
        .user_name(user_name)
        .build();
  }

}
