package org.whalebank.backend.domain.user.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerifyRequestDto {

  public String phone_num;
  public String username;

}
