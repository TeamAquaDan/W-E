package org.whalebank.backend.domain.friend.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.friend.FriendshipEntity;
import org.whalebank.backend.domain.user.UserEntity;

public interface FriendshipRepository extends JpaRepository<FriendshipEntity, Integer> {

  Optional<FriendshipEntity> findByToUserAndFromUser(UserEntity from, UserEntity to);

  List<FriendshipEntity> findByToUserAndStatusOrderByCreatedDtmAsc(UserEntity user, int status);
}
