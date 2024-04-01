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
  private String room_name; // 방 제목
  private String dutchpay_date; // 결제 일자
  private int manager_id; // 방장
  private boolean is_completed; // 완료 여부
  private int member_num; // 총 인원수
  private List<String> profile_img; // 친구 프로필사진


  public static DutchpayRoomResponseDto from(DutchpayRoomEntity dutchpayRoom,
      List<String> profileImg) {
    return DutchpayRoomResponseDto
        .builder()
        .room_id(dutchpayRoom.getRoomId())
        .room_name(dutchpayRoom.getRoomName())
        .dutchpay_date(String.valueOf(dutchpayRoom.getDutchpayDate()))
        .manager_id(dutchpayRoom.getManagerId())
        .is_completed(dutchpayRoom.isCompleted())
        .member_num(profileImg.size())  // 방장 포함 인원수
        .profile_img(profileImg)  // 방장 프로필 포함
        .build();
  }
}
