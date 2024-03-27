package org.whalebank.backend.domain.dutchpay.dto.response;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;
import org.whalebank.backend.global.openfeign.card.response.CardHistoryResponse.CardHistoryDetail;

@Setter
@Getter
@Builder
public class PaymentResponseDto {

  private int trans_id; // 거래 고유번호

  private String member_store_name; // 거래제목

  private int trans_amt;  // 거래 금액

  private String category;  // 카테고리

  public static PaymentResponseDto from(List<CardHistoryDetail> cardHistoryList) {
    return PaymentResponseDto
        .builder()

        .build();
  }
  public static String convertCodetoCategory(String code) {
    return switch (code.substring(0, 2)) {
      case "30", "31", "32" -> "003"; // 생활
      case "90", "91" -> "004"; // 주거/통신
      case "40", "42", "44" -> "006";
      case "71" -> "007";
      case "70", "84" -> "008";
      case "20", "21", "22" -> "009";
      case "50", "51", "52" -> "013";
      case "80", "81" -> "014";
      default -> "000";
    };
  }

}

