package org.whalebank.backend.domain.allowance.repository;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.allowance.GroupEntity;

public interface GroupRepository extends JpaRepository<GroupEntity, Integer> {

}
