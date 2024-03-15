package org.whalebank.whalebank.domain.auth.service;

import jakarta.transaction.Transactional;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.whalebank.domain.auth.AuthEntity;
import org.whalebank.whalebank.domain.auth.dto.response.AuthResponse;
import org.whalebank.whalebank.domain.auth.repository.AuthRepository;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class AuthServiceImpl implements AuthService {

  private final AuthRepository authRepository;
  @Override
  public AuthResponse getPhonenum(String userCi) {
    Optional<AuthEntity> auth = authRepository.findByCi(userCi);
    if(auth != null){
      return new AuthResponse(auth.get().getPhoneNum());
    } else {
      return null;
    }
  }
}
