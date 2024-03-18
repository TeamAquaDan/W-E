package org.whalebank.backend.domain.user.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class VerifyResponseDto {

  public int user_id;
  public String username;

  public static VerifyResponseDto of(int userId, String userName) {
    return VerifyResponseDto.builder()
        .user_id(userId)
        .username(userName)
        .build();
  }

}
