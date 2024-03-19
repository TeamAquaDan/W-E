package org.whalebank.backend.domain.friend.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.friend.FriendId;
import org.whalebank.backend.domain.user.UserEntity;

public interface FriendRepository extends JpaRepository<FriendEntity, FriendId> {

  @Query("SELECT f FROM FriendEntity f JOIN FETCH f.friendId.user u WHERE u = :user")
  List<FriendEntity> findByUser(@Param("user") UserEntity user);

  Optional<FriendEntity> findFriendEntityByFriendId(FriendId id);
}
