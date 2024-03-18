package org.whalebank.backend.domain.friend;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.whalebank.backend.domain.user.UserEntity;

@Entity
@Table(name="friend")
@Getter
public class FriendEntity {

  @EmbeddedId
  public FriendId friendId;

  private String friendNickname;

  public static FriendEntity createEntity(UserEntity user, UserEntity friend) {
    FriendEntity entity = new FriendEntity();
    entity.friendId = new FriendId(user, friend);
    entity.friendNickname = friend.getUserName();
    return entity;
  }

}
