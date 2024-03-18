package org.whalebank.whalebank.domain.auth.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalebank.whalebank.domain.auth.AuthEntity;

@Repository
public interface AuthRepository extends JpaRepository<AuthEntity, String> {

  Optional<AuthEntity> findByUserCi(String userCi);
}
