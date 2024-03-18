package org.whalebank.whalebank.domain.account.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.whalebank.domain.account.AccountEntity;

public interface AccountRepository extends JpaRepository<AccountEntity, String> {
}
