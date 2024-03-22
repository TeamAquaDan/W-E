package org.whalebank.backend.domain.goal.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.goal.GoalEntity;

public interface GoalRepository extends JpaRepository<GoalEntity, String> {


  boolean findByAccountIdAndStatus(int accountId, int status);
}
