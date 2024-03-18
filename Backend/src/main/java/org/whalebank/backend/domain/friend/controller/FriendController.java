package org.whalebank.backend.domain.friend.controller;

import io.swagger.v3.oas.annotations.Operation;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
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

}
