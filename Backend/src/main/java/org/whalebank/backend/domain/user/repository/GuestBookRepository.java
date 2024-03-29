package org.whalebank.backend.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.user.GuestBookEntity;

public interface GuestBookRepository extends JpaRepository<GuestBookEntity, Integer> {

}
