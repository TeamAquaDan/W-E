package org.whalecard.whalecard.domain.transaction.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalecard.whalecard.domain.transaction.TransactionEntity;

@Repository
public interface TransactionRepository extends JpaRepository<TransactionEntity, String> {


}
