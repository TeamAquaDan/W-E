package org.whalebank.backend.domain.allowance.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.user.Role;

public interface RoleRepository extends JpaRepository<RoleEntity, Integer> {

  List<RoleEntity> findRoleEntitiesByUserGroupAndRole(GroupEntity group, Role userRole);

}
