package org.whalebank.backend.domain.friend.service;

import jakarta.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.friend.FriendId;
import org.whalebank.backend.domain.friend.FriendshipEntity;
import org.whalebank.backend.domain.friend.dto.request.FriendManageRequestDto;
import org.whalebank.backend.domain.friend.dto.request.UpdateFriendNicknameRequestDto;
import org.whalebank.backend.domain.friend.dto.response.FriendManageResponseDto;
import org.whalebank.backend.domain.friend.dto.response.FriendResponseDto;
import org.whalebank.backend.domain.friend.dto.response.UpdateFriendNicknameResponseDto;
import org.whalebank.backend.domain.friend.repository.FriendRepository;
import org.whalebank.backend.domain.friend.repository.FriendshipRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class FriendServiceImpl implements FriendService {

  private final FriendRepository friendRepository;
  private final AuthRepository userRepository;
  private final FriendshipRepository friendshipRepository;

  @Override
  public List<FriendResponseDto> findAllMyFriends(String loginId) {
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    return friendRepository.findByUser(user)
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

  // 친구 요청
  @Override
  @Transactional
  public void requestFriend(String requester, int receiverId) {
    UserEntity user = getCurrentUser(requester); // 현재 사용자, 친구 신청한 사용자
    UserEntity receiver = userRepository.findById(receiverId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
    friendshipRepository.save(FriendshipEntity.of(user, receiver));

    // TODO: receiver에게 푸시 알림 보내기
  }

  private UserEntity getCurrentUser(String loginId) {
    return userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
  }

  // 친구 요청 관리
  @Override
  @Transactional
  public FriendManageResponseDto manageFriendRequest(String currentUser, FriendManageRequestDto reqDto) {
    UserEntity receiver = getCurrentUser(currentUser); // 현재 사용자, 친구 요청 받은 사용자
    UserEntity requester = userRepository.findById(reqDto.getUser_id()) // 친구 요청한 사용자
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    FriendshipEntity friendshipEntity = friendshipRepository.findByToUserAndFromUser(receiver, requester)
        .orElseThrow(() -> new CustomException(ResponseCode.FRIENDSHIP_NOT_FOUND));

    // 친구 요청 승인/거절한다
    if(reqDto.getStatus()==1) {
      // accepted
      // a와 b는 친구, b와 a는 친구
      FriendEntity entity1 = FriendEntity.createEntity(requester, receiver);
      FriendEntity entity2 = FriendEntity.createEntity(receiver, requester);
      friendRepository.save(entity1);
      friendRepository.save(entity2);

      // TODO: 요청자에게 푸시 알림 보내기

    } else if(reqDto.getStatus()>2 || reqDto.getStatus()<=0) {
      throw new CustomException(ResponseCode.INVALID_FRIENDSHIP_REQ);
    }

    friendshipEntity.updateStatus(reqDto.getStatus());
    return FriendManageResponseDto.of(reqDto.getStatus(), requester.getUserName());
  }

  @Transactional
  @Override
  public UpdateFriendNicknameResponseDto updateNickname(String currentUser,
      UpdateFriendNicknameRequestDto reqDto) {
    UserEntity loginUser = getCurrentUser(currentUser); // 현재 사용자
    UserEntity friendUser = userRepository.findById(reqDto.getUser_id()) // 친구
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 친구 별칭 수정하기
    // user, friend로 찾기 -> friend_nickname 수정
    FriendEntity entity = friendRepository.findFriendEntityByFriendId(new FriendId(loginUser, friendUser))
        .orElseThrow(() -> new CustomException(ResponseCode.FRIEND_NOT_FOUND));
    entity.updateNickname(reqDto.getNickname());

    return UpdateFriendNicknameResponseDto.from(friendUser, entity.getFriendNickname());
  }
}
