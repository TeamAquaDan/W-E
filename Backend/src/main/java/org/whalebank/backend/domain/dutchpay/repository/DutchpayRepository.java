package org.whalebank.backend.domain.dutchpay.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;

public interface DutchpayRepository extends JpaRepository<DutchpayEntity, String> {

  List<DutchpayEntity> findByUserId(int userId);

  List<DutchpayEntity> findByRoomId(int roomId);
}
