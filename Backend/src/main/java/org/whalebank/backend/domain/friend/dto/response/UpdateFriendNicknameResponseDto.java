package org.whalebank.backend.domain.friend.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
@Builder
public class UpdateFriendNicknameResponseDto {

  private int friend_id;
  private String friend_nickname;
  private String friend_profileImg;
  private String friend_name;

  public static UpdateFriendNicknameResponseDto from(UserEntity friend, String friend_nickname) {
    return UpdateFriendNicknameResponseDto.builder()
        .friend_id(friend.getUserId())
        .friend_nickname(friend_nickname)
        .friend_profileImg(friend.getProfileImage())
        .build();
  }

}
