package org.whalebank.backend.domain.friend.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
@Builder
public class FriendResponseDto {

  int friend_id;
  String friend_nickname;
  String friend_profileImg;
  String friend_name;
  String friend_loginid;

  public static FriendResponseDto from(FriendEntity friendEntity) {
    UserEntity friend = friendEntity.friendId.getFriend();
    return FriendResponseDto.builder()
        .friend_id(friend.getUserId())
        .friend_nickname(friendEntity.getFriendNickname())
        .friend_profileImg(friend.getProfile().getProfileImage())
        .friend_name(friend.getUserName())
        .friend_loginid(friend.getLoginId())
        .build();
  }


}
