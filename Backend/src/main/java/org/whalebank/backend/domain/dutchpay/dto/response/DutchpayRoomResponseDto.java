package org.whalebank.backend.domain.dutchpay.dto.response;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;

@Getter
@Setter
@Builder
public class DutchpayRoomResponseDto {

  private int room_id; // 방아이디
  private int manager_id; // 방장
  private boolean is_completed; // 완료 여부
  private List<String> profile_img; // 친구 프로필사진

  public static DutchpayRoomResponseDto from(DutchpayRoomEntity dutchpayRoom,
      List<String> profileImg) {
    return DutchpayRoomResponseDto
        .builder()
        .room_id(dutchpayRoom.getRoomId())
        .manager_id(dutchpayRoom.getManagerId())
        .is_completed(dutchpayRoom.isCompleted())
        .profile_img(profileImg)
        .build();
  }
}
