package org.whalebank.backend.domain.goal.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.goal.GoalEntity;

public interface GoalRepository extends JpaRepository<GoalEntity, String> {

}
