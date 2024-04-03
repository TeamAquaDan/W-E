package org.whalebank.backend.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.whalebank.backend.domain.user.ProfileEntity;

@Repository
public interface ProfileRepository extends JpaRepository<ProfileEntity, String> {

}
