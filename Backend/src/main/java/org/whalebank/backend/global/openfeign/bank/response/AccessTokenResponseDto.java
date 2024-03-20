package org.whalebank.backend.global.openfeign.bank.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AccessTokenResponseDto {

  public String token_type;
  public String access_token;
  public String refresh_token;

}
