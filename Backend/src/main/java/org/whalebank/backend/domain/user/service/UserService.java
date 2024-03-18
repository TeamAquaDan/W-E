package org.whalebank.backend.domain.user.service;

import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;

public interface UserService {

  public ProfileResponseDto getProfile(int userId, String loginId);

}
