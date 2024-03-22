package org.whalebank.backend.domain.accountbook;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.user.UserEntity;

public interface AccountBookRepository extends JpaRepository<AccountBookEntity, Integer> {

  List<AccountBookEntity> findAllByUserAndAccountBookDtmBetweenOrderByAccountBookDtmDesc(
      UserEntity user, LocalDateTime starts, LocalDateTime ends);

}
