package org.whalebank.backend.domain.friend.service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.friend.dto.response.FriendResponseDto;
import org.whalebank.backend.domain.friend.repository.FriendRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class FriendServiceImpl implements FriendService {

  private final FriendRepository repository;
  private final AuthRepository userRepository;

  @Override
  public List<FriendResponseDto> findAllMyFriends(String loginId) {
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    return repository.findByUser(user)
        .stream().map(FriendResponseDto::from)
        .collect(Collectors.toList());
  }

  @Override
  public List<FriendResponseDto> findFriendsByName(String loginId, String name) {
    List<FriendResponseDto> friendList = this.findAllMyFriends(loginId);

    return friendList.stream()
        .filter(friend -> friend.getFriend_name().contains(name))
        .collect(Collectors.toList());
  }
}
