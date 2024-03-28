package org.whalebank.backend.domain.dutchpay.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.dutchpay.CategoryCalculateEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;

public interface CategoryCalculateRepository extends
    JpaRepository<CategoryCalculateEntity, Integer> {

  CategoryCalculateEntity findByCategory(String category);

  List<CategoryCalculateEntity> findByRoomId(DutchpayRoomEntity room);
}
