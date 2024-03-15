package org.whalebank.backend.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.user.UserEntity;

public interface AuthRepository extends JpaRepository<UserEntity, Integer> {

}
