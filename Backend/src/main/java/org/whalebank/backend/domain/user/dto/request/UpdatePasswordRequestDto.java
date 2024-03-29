package org.whalebank.backend.domain.user.dto.request;

import lombok.Getter;

@Getter
public class UpdatePasswordRequestDto {

  public String password; // 비밀번호
  public String new_password; // 새 비밀번호

}
