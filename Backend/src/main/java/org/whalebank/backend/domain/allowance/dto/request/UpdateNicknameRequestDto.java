package org.whalebank.backend.domain.allowance.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateNicknameRequestDto {

  public int group_id;
  public String group_nickname;

}
