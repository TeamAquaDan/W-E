package org.whalebank.backend.domain.user.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterMainAccountRequestDto {

  public int account_id;
  public String account_num;

}
