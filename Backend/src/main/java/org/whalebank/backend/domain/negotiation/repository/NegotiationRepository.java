package org.whalebank.backend.domain.negotiation.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.negotiation.NegotiationEntity;

public interface NegotiationRepository extends JpaRepository<NegotiationEntity, Integer> {

}
