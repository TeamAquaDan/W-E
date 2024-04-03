package org.whalebank.backend.domain.friend.service;

import static org.junit.jupiter.api.Assertions.*;

import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import java.time.LocalDate;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.friend.FriendId;
import org.whalebank.backend.domain.friend.repository.FriendRepository;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;

@Transactional
@SpringBootTest
class FriendServiceImplTest {

  @Autowired
  private EntityManager entityManager;
  @Autowired
  private FriendRepository repository;

  @Test
  public void 내_친구_조회() {
    UserEntity user1 = UserEntity.builder()
        .userName("김가영")
        .role(Role.CHILD)
        .accountId(4)
        .phoneNum("01099263463")
        .loginId("kky")
        .loginPassword("string")
        .build();

    UserEntity user2 = UserEntity.builder()
        .userName("김나영")
        .role(Role.CHILD)
        .accountId(5)
        .phoneNum("01099303463")
        .loginId("kky2")
        .loginPassword("string")
        .build();

    UserEntity user3 = UserEntity.builder()
        .userName("김다영")
        .role(Role.CHILD)
        .accountId(6)
        .phoneNum("01023453463")
        .loginId("kky3")
        .loginPassword("string")
        .build();

    UserEntity user4 = UserEntity.builder()
        .userName("김싸피")
        .role(Role.CHILD)
        .accountId(7)
        .phoneNum("01077773463")
        .loginId("kky4")
        .loginPassword("string")
        .build();

    entityManager.persist(user1);
    entityManager.persist(user2);
    entityManager.persist(user3);
    entityManager.persist(user4);

    FriendEntity fe = FriendEntity.createEntity(user1, user2);
    FriendEntity fe2 = FriendEntity.createEntity(user1, user3);
    FriendEntity fe3 = FriendEntity.createEntity(user4, user2);
    FriendEntity fe4 = FriendEntity.createEntity(user4, user3);
    entityManager.persist(fe);
    entityManager.persist(fe2);
    entityManager.persist(fe3);
    entityManager.persist(fe4);

    Assertions.assertEquals(repository.findByUser(user1).size(),2);
    //Assertions.assertEquals(repository.findByUser(user4).size(), 2);


  }

}