package org.whalebank.backend.domain.dutchpay.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.dutchpay.CategoryCalculateEntity;

public interface CategoryCalculateRepository extends JpaRepository<CategoryCalculateEntity, Integer> {

  CategoryCalculateEntity findByCategory(String category);
}
