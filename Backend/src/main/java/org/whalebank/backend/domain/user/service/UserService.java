package org.whalebank.backend.domain.user.service;

import org.whalebank.backend.domain.user.dto.request.VerifyRequestDto;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;
import org.whalebank.backend.domain.user.dto.response.VerifyResponseDto;

public interface UserService {

  public ProfileResponseDto getProfile(int userId, String loginId);

  public VerifyResponseDto verifyUser(VerifyRequestDto reqDto);

}
