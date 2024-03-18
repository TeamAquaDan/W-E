package org.whalebank.whalebank.domain.account.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.whalebank.domain.auth.AuthEntity;

public interface AccountRespository extends JpaRepository<AuthEntity, String> {

}
