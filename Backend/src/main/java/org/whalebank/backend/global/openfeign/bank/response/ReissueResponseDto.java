package org.whalebank.backend.global.openfeign.bank.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReissueResponseDto {

  public String token_type;
  public String access_token;

}
