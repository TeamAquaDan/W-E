package org.whalebank.backend.domain.notification.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalebank.backend.domain.notification.dto.response.NotiResponseDto;
import org.whalebank.backend.domain.notification.service.NotiService;
import org.whalebank.backend.global.response.ApiResponse;

@RequestMapping("/api/noti")
@RestController
@Tag(name="알림 관련 API")
@RequiredArgsConstructor
public class NotiController {

  private final NotiService notiService;

  @GetMapping("")
  @Operation(summary = "알림 목록 조회", description = "내가 받은 알림 목록 조회")
  public ApiResponse<List<NotiResponseDto>> getNotifications(@AuthenticationPrincipal UserDetails loginUser) {
    return ApiResponse.ok("알림 목록 조회 성공", notiService.getAllNotification(loginUser.getUsername()));
  }

  @PatchMapping("/{noti_id}")
  @Operation(summary = "알림 단건 조회", description = "noti_id에 해당하는 알림을 읽음 처리함")
  public ApiResponse<?> readNotification(@AuthenticationPrincipal UserDetails loginUser,
      @PathVariable("noti_id") int notiId) {
    notiService.readNotification(loginUser.getUsername(), notiId);
    return ApiResponse.ok("알림 읽음 성공");
  }


}
