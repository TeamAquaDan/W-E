package org.whalebank.whalebank.domain.auth.service;

import org.springframework.stereotype.Service;
import org.whalebank.whalebank.domain.auth.dto.response.AuthResponse;

public interface AuthService {

  AuthResponse getPhonenum(String userCi);
}
