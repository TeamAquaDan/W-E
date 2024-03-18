package org.whalebank.whalebank.domain.account.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.auth.AuthEntity;

public interface AccountRepository extends JpaRepository<AccountEntity, String> {

  AccountEntity findByAccountNum(String accountNum);
}
