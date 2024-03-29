package org.whalebank.backend.domain.user.dto.request;

import lombok.Getter;

@Getter
public class GuestBookRequestDto {

  public int user_id; // 프로필 사용자 아이디
  public String content;  // 방명록 내용

}
