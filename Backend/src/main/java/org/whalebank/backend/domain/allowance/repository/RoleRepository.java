package org.whalebank.backend.domain.allowance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.allowance.RoleEntity;

public interface RoleRepository extends JpaRepository<RoleEntity, Integer> {

}
