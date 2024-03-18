package org.whalebank.backend.domain.user.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginRequestDto {

  public String login_id;
  public String password;

}
