package org.whalebank.backend.domain.user.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ReissueResponseDto {

  public String access_token;
  public String refresh_token;

}
