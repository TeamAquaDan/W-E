package org.whalebank.backend.domain.dutchpay.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;
import org.whalebank.backend.domain.user.UserEntity;

public interface DutchpayRepository extends JpaRepository<DutchpayEntity, Integer> {

  List<DutchpayEntity> findByUser(UserEntity user);

  List<DutchpayEntity> findByRoom(DutchpayRoomEntity dutchpayRoom);

  DutchpayEntity findByUserAndRoom(UserEntity user, DutchpayRoomEntity dutchpayRoom);

  DutchpayEntity findByDutchpayIdAndRoom(int dutchpayId, DutchpayRoomEntity dutchpayRoom);
}
