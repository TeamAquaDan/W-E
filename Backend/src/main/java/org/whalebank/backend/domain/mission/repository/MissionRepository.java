package org.whalebank.backend.domain.mission.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.mission.MissionEntity;

public interface MissionRepository extends JpaRepository<MissionEntity, Integer> {

  List<MissionEntity> findAllByGroup(GroupEntity group);

}
