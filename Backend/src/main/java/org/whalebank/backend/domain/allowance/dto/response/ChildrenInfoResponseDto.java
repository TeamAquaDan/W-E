package org.whalebank.backend.domain.allowance.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
@Builder
public class ChildrenInfoResponseDto {

  public int user_id;
  public int group_id;
  public String profile_img;
  public String group_nickname;

  public static ChildrenInfoResponseDto from(RoleEntity entity) {
    UserEntity user = entity.getUser();
    return ChildrenInfoResponseDto.builder()
        .user_id(user.getUserId())
        .group_id(entity.getUserGroup().getGroupId())
        .profile_img(user.getProfile().getProfileImage())
        .group_nickname(entity.getGroupNickname())
        .build();
  }

}
