package org.whalebank.backend.domain.dutchpay.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;

public interface DutchpayRepository extends JpaRepository<DutchpayEntity, String> {

}
