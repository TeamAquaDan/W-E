package org.whalecard.whalecard.domain.auth.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalecard.whalecard.domain.auth.AuthEntity;
import org.whalecard.whalecard.domain.card.CardEntity;

@Repository
public interface AuthRepository extends JpaRepository<AuthEntity, String> {

  Optional<AuthEntity> findByUserCi(String userCi);

}
