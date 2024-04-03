package org.whalebank.whalebank.domain.transfer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalebank.whalebank.domain.transfer.TransferEntity;

@Repository
public interface TransferRepository extends JpaRepository<TransferEntity, String> {

}
