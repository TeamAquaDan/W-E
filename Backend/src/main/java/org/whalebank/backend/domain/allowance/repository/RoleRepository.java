package org.whalebank.backend.domain.allowance.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;

public interface RoleRepository extends JpaRepository<RoleEntity, Integer> {

  List<RoleEntity> findRoleEntitiesByUserGroupAndRole(GroupEntity group, Role userRole);

  @EntityGraph(attributePaths = {"userGroup","user"})
  Optional<RoleEntity> findByUserGroupAndUser(GroupEntity group, UserEntity user);

  @Query("SELECT r FROM RoleEntity r " +
      "WHERE r.userGroup IN" +
      "(SELECT g.userGroup FROM RoleEntity g " +
      "JOIN g.user gu " +
      "ON gu.userId = :userId) " +
      "AND r.role = :role")
  List<RoleEntity> findRolesByUserId(@Param("userId") int userId, @Param("role") Role role);

  List<RoleEntity> findByUserGroupAndRole(GroupEntity group, Role role);

}
