package org.whalebank.backend.domain.dutchpay.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.dutchpay.SelectedPaymentEntity;

@Repository
public interface SelectedPaymentRepository extends JpaRepository<SelectedPaymentEntity, String> {

  List<SelectedPaymentEntity> findByDutchpay(DutchpayEntity dutchpay);
}
