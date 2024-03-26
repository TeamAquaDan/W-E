package org.whalebank.backend.domain.dutchpay.dto.request;

import java.util.List;
import lombok.Getter;

@Getter
public class DutchpayRoomRequestDto {

  public String room_name;  // 방 제목
  public String dutchpay_date; // 결제 일자
  public List<Integer> member;  // 초대할 친구 아이디

}
