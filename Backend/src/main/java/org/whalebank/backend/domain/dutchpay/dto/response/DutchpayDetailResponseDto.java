package org.whalebank.backend.domain.dutchpay.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;

@Getter
@Setter
@Builder
public class DutchpayDetailResponseDto {

  private int dutchpay_id;  // 더치페이 아이디
  private String profileImage;  // 프로필 이미지
  private String userName;  // 이름
  private int totalAmt; // 결제총액
  private boolean isCompleted;  // 정산금액 송금여부

  public static DutchpayDetailResponseDto from(DutchpayEntity dutchpay){
    return DutchpayDetailResponseDto
        .builder()
        .dutchpay_id(dutchpay.getDutchpayId())
        .profileImage(dutchpay.getUser().getProfile().getProfileImage())
        .userName(dutchpay.getUser().getUserName())
        .totalAmt(dutchpay.getTotalAmt())
        .isCompleted(dutchpay.isCompleted())
        .build();
  }
}
