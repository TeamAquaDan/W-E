package org.whalebank.backend.domain.dutchpay.repository;

import java.util.Collection;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;
import org.whalebank.backend.domain.user.UserEntity;

public interface DutchpayRepository extends JpaRepository<DutchpayEntity, String> {

  List<DutchpayEntity> findByUser(UserEntity user);

  List<DutchpayEntity> findByRoom(DutchpayRoomEntity dutchpayRoom);
}
