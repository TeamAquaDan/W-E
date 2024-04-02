package org.whalebank.backend.domain.notification.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.notification.NotificationEntity;
import org.whalebank.backend.domain.user.UserEntity;

public interface NotiRepository extends JpaRepository<NotificationEntity, Integer> {

  List<NotificationEntity> findAllByUserOrderByCreatedDtmDesc(UserEntity user);

  List<NotificationEntity> findAllByUser(UserEntity user);

}
