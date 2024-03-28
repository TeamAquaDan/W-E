package org.whalebank.backend.domain.allowance;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "auto_payment")
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AutoPaymentEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int autoPaymentId;

  private String recvAccountNum; // 용돈 받는 계좌

  private String parentAccountNum; // 용돈 주는 계좌 번호

  private String parentAccountPassword; // 용돈 주는 계좌 비밀번호

  private int reservedAmt; // 용돈 금액

//  private String childName; // 용돈 받는 사람 이름

  private LocalDate scheduledDate; // 다음 이체 날짜

  public static AutoPaymentEntity of(RoleEntity child, RoleEntity parent, String password,
      int allowanceAmt,
      LocalDate nextAutoPaymentDate) {
    return AutoPaymentEntity.builder()
        .recvAccountNum(child.getAccountNum())
        .parentAccountNum(parent.getAccountNum())
        .parentAccountPassword(password)
        .reservedAmt(allowanceAmt)
        .scheduledDate(nextAutoPaymentDate)
        .build();
  }

}
