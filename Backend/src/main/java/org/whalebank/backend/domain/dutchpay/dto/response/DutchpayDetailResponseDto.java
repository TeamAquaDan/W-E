package org.whalebank.backend.domain.dutchpay.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
@Builder
public class DutchpayDetailResponseDto {

  private int dutchpay_id;  // 더치페이 아이디
  private String profile_image;  // 프로필 이미지
  private String user_name;  // 이름
  private int total_amt; // 결제총액
  private boolean is_completed;  // 정산금액 송금여부
  private boolean is_login_user;  // 로그인한 유저와 같은 사람인지 여부

  public static DutchpayDetailResponseDto from(DutchpayEntity dutchpay, UserEntity user) {
    return DutchpayDetailResponseDto
        .builder()
        .dutchpay_id(dutchpay.getDutchpayId())
        .profile_image(dutchpay.getUser().getProfile().getProfileImage())
        .user_name(dutchpay.getUser().getUserName())
        .total_amt(dutchpay.getTotalAmt())
        .is_completed(dutchpay.isCompleted())
        .is_login_user(dutchpay.getUser().equals(user))
        .build();
  }
}
