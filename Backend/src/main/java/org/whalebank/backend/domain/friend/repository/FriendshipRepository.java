package org.whalebank.backend.domain.friend.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.friend.FriendshipEntity;
import org.whalebank.backend.domain.user.UserEntity;

public interface FriendshipRepository extends JpaRepository<FriendshipEntity, Integer> {

  List<FriendshipEntity> findAllByToUserAndFromUserAndStatus(UserEntity to, UserEntity from, int status);


  List<FriendshipEntity> findByToUserAndStatusOrderByCreatedDtmAsc(UserEntity user, int status);
}
