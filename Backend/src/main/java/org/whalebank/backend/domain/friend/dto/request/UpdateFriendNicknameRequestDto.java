package org.whalebank.backend.domain.friend.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateFriendNicknameRequestDto {

  private int user_id;
  private String nickname;

}
