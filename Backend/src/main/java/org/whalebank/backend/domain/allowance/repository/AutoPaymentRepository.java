package org.whalebank.backend.domain.allowance.repository;

import java.time.LocalDate;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.allowance.AutoPaymentEntity;

public interface AutoPaymentRepository extends JpaRepository<AutoPaymentEntity, Integer> {

  List<AutoPaymentEntity> findAllByScheduledDate(LocalDate scheduledDate);

}
