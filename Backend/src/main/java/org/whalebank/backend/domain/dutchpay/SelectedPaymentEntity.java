package org.whalebank.backend.domain.dutchpay;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.whalebank.backend.domain.dutchpay.dto.request.RegisterPaymentRequestDto.Transaction;

@Entity
@Table(name = "selected_payment")
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SelectedPaymentEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int selectedPaymentId;

  @ManyToOne
  @JoinColumn(name = "dutchpay_id")
  private DutchpayEntity dutchpay;

  private int transId; // 거래 고유 번호

  private int transAmt; // 거래 금액

  private String category;  // 카테고리

  private String memberStoreName; // 거래 제목

  private int roomId; // 더치페이 방 아이디

  public static SelectedPaymentEntity from(DutchpayEntity dutchpay, Transaction transaction) {
    return SelectedPaymentEntity
        .builder()
        .dutchpay(dutchpay)
        .transId(transaction.getTrans_id())
        .transAmt(transaction.getTrans_amt())
        .category(transaction.getCategory())
        .memberStoreName(transaction.getMember_storeName())
        .roomId(dutchpay.getRoom().getRoomId())
        .build();
  }
}
