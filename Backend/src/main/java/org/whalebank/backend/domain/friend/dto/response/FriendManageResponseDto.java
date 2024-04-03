package org.whalebank.backend.domain.friend.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class FriendManageResponseDto {

  private String result;
  private String friend_name;

  public static FriendManageResponseDto of(int status, String name) {
    return FriendManageResponseDto.builder()
        .result((status==1)?"승인":"거절")
        .friend_name(name)
        .build();
  }

}
