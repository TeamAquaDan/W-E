package org.whalebank.whalebank.domain.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalebank.whalebank.domain.auth.AuthEntity;

@Repository
public interface AuthRepository extends JpaRepository<AuthEntity, String> {

  AuthEntity findByCi(String userCi);
}
