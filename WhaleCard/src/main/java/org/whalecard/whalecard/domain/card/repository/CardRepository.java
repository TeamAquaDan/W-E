package org.whalecard.whalecard.domain.card.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalecard.whalecard.domain.card.CardEntity;

@Repository
public interface CardRepository extends JpaRepository<CardEntity, String> {

}
