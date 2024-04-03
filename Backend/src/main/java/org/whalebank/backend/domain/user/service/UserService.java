package org.whalebank.backend.domain.user.service;

import org.springframework.web.multipart.MultipartFile;
import org.whalebank.backend.domain.user.dto.request.GuestBookRequestDto;
import org.whalebank.backend.domain.user.dto.request.RegisterMainAccountRequestDto;
import org.whalebank.backend.domain.user.dto.request.VerifyRequestDto;
import org.whalebank.backend.domain.user.dto.response.ProfileImageResponseDto;
import org.whalebank.backend.domain.user.dto.response.ProfileResponseDto;
import org.whalebank.backend.domain.user.dto.response.VerifyResponseDto;

public interface UserService {

  public ProfileResponseDto getProfile(int userId, String loginId);

  public VerifyResponseDto verifyUser(VerifyRequestDto reqDto);

  void updateMainAccount(String loginId, RegisterMainAccountRequestDto reqDto);

  ProfileImageResponseDto updateProfileImage(String loginId, MultipartFile file);

  void updateSentence(String loginId, String sentence);

  void createGuestBook(String loginId, GuestBookRequestDto request);

  void deleteGuestBook(String loginId, int guestBookId);

  void updateLastCardHistoryFetchTime(String loginId);
}
