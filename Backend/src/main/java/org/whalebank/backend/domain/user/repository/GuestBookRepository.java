package org.whalebank.backend.domain.user.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.whalebank.backend.domain.user.GuestBookEntity;
import org.whalebank.backend.domain.user.ProfileEntity;

public interface GuestBookRepository extends JpaRepository<GuestBookEntity, Integer> {

  List<GuestBookEntity> findByProfile(ProfileEntity profile);
}
