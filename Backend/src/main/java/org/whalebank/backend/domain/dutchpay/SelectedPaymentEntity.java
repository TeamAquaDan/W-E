package org.whalebank.backend.domain.dutchpay;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name="selected_payment")
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SelectedPaymentEntity {

  @Id
  @ManyToOne
  @JoinColumn(name = "dutchpay_id")
  private DutchpayEntity dutchpayId;

  private int transId; // 거래 고유 번호

  private int transAmt; // 거래 금액

  private String category;  // 카테고리

  private String memberStoreName; // 거래 제목

}
