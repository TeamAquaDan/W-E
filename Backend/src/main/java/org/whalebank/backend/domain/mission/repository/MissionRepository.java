package org.whalebank.backend.domain.mission.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.mission.MissionEntity;
import org.whalebank.backend.domain.user.UserEntity;

public interface MissionRepository extends JpaRepository<MissionEntity, Integer> {

  @Query("SELECT m FROM MissionEntity m " +
      "WHERE m.group.groupId IN " +
      "(SELECT DISTINCT g.groupId " +
      "FROM GroupEntity g " +
      "JOIN RoleEntity r ON g = r.userGroup " +
      "WHERE r.user = :user)")
  List<MissionEntity> findAllMissionByUserOrderByDeadlineDateAsc(@Param("user") UserEntity user);

  List<MissionEntity> findAllByGroupOrderByDeadlineDateAsc(GroupEntity group);

}
