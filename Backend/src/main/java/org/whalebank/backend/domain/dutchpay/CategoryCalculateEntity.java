package org.whalebank.backend.domain.dutchpay;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.util.HashMap;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "category_calculate")
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CategoryCalculateEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int categoryCalculateId;

  @ManyToOne
  @JoinColumn(name = "room_id")
  private DutchpayRoomEntity roomId;  // 외래 키로 설정된 DutchpayRoomEntity의 room_id

  private String category;  // 카테고리
  private int totalAmt; // 카테고리별 금액

  public static CategoryCalculateEntity create(SelectedPaymentEntity selectedPayment,
      DutchpayRoomEntity dutchpayRoom) {
    return CategoryCalculateEntity
        .builder()
        .category(selectedPayment.getCategory())
        .totalAmt(selectedPayment.getTransAmt())
        .roomId(dutchpayRoom)
        .build();
  }
}
