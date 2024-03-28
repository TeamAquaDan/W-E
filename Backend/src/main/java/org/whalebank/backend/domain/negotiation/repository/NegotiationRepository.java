package org.whalebank.backend.domain.negotiation.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.negotiation.NegotiationEntity;

public interface NegotiationRepository extends JpaRepository<NegotiationEntity, Integer> {

  List<NegotiationEntity> findAllByGroupOrderByCreateDtmDesc(GroupEntity group);

  Optional<NegotiationEntity> findByNegoIdAndGroup(int negoId, GroupEntity group);

}
