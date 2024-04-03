package org.whalebank.whalebank.domain.account.repository;


import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.whalebank.domain.account.AccountEntity;

public interface AccountRepository extends JpaRepository<AccountEntity, String> {

  AccountEntity findByBankCodeAndAccountNum(String bankCode, String accountNum);

  List<AccountEntity> findByUserId(String userId);
}
