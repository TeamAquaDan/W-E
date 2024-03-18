package org.whalebank.backend.domain.user.dto.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TokenResponseDto {

  String access_token;
  String refresh_token;

}
