package org.whalebank.backend.domain.accountbook.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.apache.catalina.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;
import org.whalebank.backend.domain.user.UserEntity;

public interface AccountBookRepository extends JpaRepository<AccountBookEntity, Integer> {

  List<AccountBookEntity> findAllByUserAndAccountBookDtmBetweenAndIsHideFalseOrderByAccountBookDtmDesc(
      UserEntity user, LocalDateTime starts, LocalDateTime ends);

  Optional<AccountBookEntity> findByUserAndAccountBookId(UserEntity user, int accountBookId);

  AccountBookEntity findByUserAndTransId(UserEntity user, int transId);
}
