package org.whalebank.backend.domain.mission.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.mission.MissionEntity;

public interface MissionRepository extends JpaRepository<MissionEntity, Integer> {

}
