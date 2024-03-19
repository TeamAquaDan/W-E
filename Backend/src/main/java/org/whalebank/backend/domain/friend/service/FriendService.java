package org.whalebank.backend.domain.friend.service;

import java.util.List;
import org.whalebank.backend.domain.friend.dto.response.FriendResponseDto;

public interface FriendService {

  List<FriendResponseDto> findAllMyFriends(String loginId);

  List<FriendResponseDto> findFriendsByName(String loginId, String name);

}
