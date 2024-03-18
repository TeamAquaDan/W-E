package org.whalebank.whalebank.domain.transfer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.whalebank.domain.transfer.TransferEntity;

public interface TransferRepository extends JpaRepository<TransferEntity, String> {

}
