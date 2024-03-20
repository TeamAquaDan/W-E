package org.whalebank.backend.global.openfeign.bank.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ReissueRequestDto {

  public String refresh_token;

  public static ReissueRequestDto from(String refreshToken) {
    return ReissueRequestDto.builder()
        .refresh_token(refreshToken)
        .build();
  }

}
