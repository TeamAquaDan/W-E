package org.whalebank.backend.domain.friend.service;

import java.util.List;
import org.whalebank.backend.domain.friend.dto.request.FriendManageRequestDto;
import org.whalebank.backend.domain.friend.dto.request.UpdateFriendNicknameRequestDto;
import org.whalebank.backend.domain.friend.dto.response.FriendManageResponseDto;
import org.whalebank.backend.domain.friend.dto.response.FriendResponseDto;
import org.whalebank.backend.domain.friend.dto.response.PendingRequestDto;
import org.whalebank.backend.domain.friend.dto.response.UpdateFriendNicknameResponseDto;

public interface FriendService {

  List<FriendResponseDto> findAllMyFriends(String loginId);

  List<FriendResponseDto> findFriendsByName(String loginId, String name);

  void requestFriend(String requester, int receiverId);

  FriendManageResponseDto manageFriendRequest(String currentUser, FriendManageRequestDto reqDto);

  UpdateFriendNicknameResponseDto updateNickname(String currentUser, UpdateFriendNicknameRequestDto reqDto);


  List<PendingRequestDto> findAllPendingRequest(String loginId);

  void deleteFriend(String loginId, int friendId);
}
