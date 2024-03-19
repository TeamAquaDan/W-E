package org.whalebank.backend.domain.friend.controller;

import io.swagger.v3.oas.annotations.Operation;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.friend.dto.request.FriendManageRequestDto;
import org.whalebank.backend.domain.friend.dto.request.UpdateFriendNicknameRequestDto;
import org.whalebank.backend.domain.friend.dto.response.FriendManageResponseDto;
import org.whalebank.backend.domain.friend.dto.response.FriendResponseDto;
import org.whalebank.backend.domain.friend.service.FriendService;
import org.whalebank.backend.global.response.ApiResponse;

@RequestMapping("/api/friend")
@RestController
@RequiredArgsConstructor
public class FriendController {

  private final FriendService service;

  @GetMapping("")
  @Operation(summary = "내 친구 목록 조회", description = "나의 모든 친구 목록을 조회한다")
  public ApiResponse<List<FriendResponseDto>> getAllMyFriends(@AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("친구 목록 조회 성공", service.findAllMyFriends(loginUser.getUsername()));
  }

  @GetMapping("/search")
  @Operation(summary = "내 친구 이름으로 검색", description = "내 친구목록에 있는 사람들 중 이름으로 검색한다")
  public ApiResponse<List<FriendResponseDto>> searchFriendByName(@AuthenticationPrincipal UserDetails loginUser, @RequestParam("name") String name) {
    return ApiResponse.ok("친구 검색 성공", service.findFriendsByName(loginUser.getUsername(), name));
  }

  @PostMapping("/register")
  @Operation(summary = "친구 요청", description = "요청을 수신할 친구의 id(pk)를 담아서 api를 호출한다")
  public ApiResponse<?> requestFriendship(@AuthenticationPrincipal UserDetails loginUser, @RequestBody
      Map<String, Integer> map) {
        service.requestFriend(loginUser.getUsername(), map.get("user_id"));
        return ApiResponse.ok("친구 요청 완료");
  }

  @PostMapping("/manage")
  @Operation(summary = "친구 요청 관리", description = "내가 받은 친구 신청 요청을 승인(status: 1)하거나 거절(status: 2)한다")
  public ApiResponse<FriendManageResponseDto> manageFriendship(@AuthenticationPrincipal UserDetails loginUser, @RequestBody
      FriendManageRequestDto reqDto) {
    return ApiResponse.ok("친구 요청 관리 완료", service.manageFriendRequest(loginUser.getUsername(), reqDto));
  }

  @PatchMapping("/nickname")
  @Operation(summary = "친구 별칭 수정", description = "친구 별명을 수정한다. 기본값: 친구 이름")
  public ApiResponse<?> updateFriendNickname(@AuthenticationPrincipal UserDetails loginUser,
      @RequestBody UpdateFriendNicknameRequestDto reqDto) {
    return ApiResponse.ok("친구 별칭 수정 성공", service.updateNickname(loginUser.getUsername(), reqDto));
  }

}
