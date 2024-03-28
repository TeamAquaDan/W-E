package org.whalebank.backend.domain.allowance;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.time.DayOfWeek;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Table(name = "auto_payment")
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AutoPaymentEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int autoPaymentId;

  private String recvAccountNum; // 용돈 받는 계좌

  private int parentAccountId;   // 용돈 주는 계좌 고유 번호

  private String parentAccountNum; // 용돈 주는 계좌 번호

  private String parentAccountPassword; // 용돈 주는 계좌 비밀번호

  private int reservedAmt; // 용돈 금액

  private String childName; // 용돈 받는 사람 이름

  private LocalDate scheduledDate; // 다음 이체 날짜

  @OneToOne(fetch = FetchType.LAZY, mappedBy = "autoPaymentEntity")
  GroupEntity group;

  public static AutoPaymentEntity of(RoleEntity child, RoleEntity parent, String password,
      int allowanceAmt) {
    return AutoPaymentEntity.builder()
        .recvAccountNum(child.getAccountNum())
        .parentAccountId(parent.getAccountId())
        .parentAccountNum(parent.getAccountNum())
        .parentAccountPassword(password)
        .reservedAmt(allowanceAmt)
        .childName(child.getUser().getUserName())
        .build();
  }

  public void calculateNextAutoPaymentDate(boolean isMonthly, int paymentDate) {
    LocalDate today = LocalDate.now();
    int year = today.getYear();
    int month = today.getMonth().getValue();
    LocalDate nextPaymentDate;

    if (isMonthly) {
      // 월별 지급
      if (today.getDayOfMonth() >= paymentDate) {
        // 이미 n일을 지났다면, 다음 달 paymentDate일 부터 용돈 지급
        nextPaymentDate = LocalDate.of(year, month + 1, paymentDate);
      } else {
        // 이번 달 paymentDate일 부터 용돈 지급
        nextPaymentDate = LocalDate.of(year, month, paymentDate);
      }

    } else {
      // 주별 지급
      DayOfWeek currentDayOfWeek = today.getDayOfWeek();
      int daysToAdd;
      if (currentDayOfWeek.getValue() < paymentDate) { // 4 < 6
        // 이번 주부터 용돈 지급
        daysToAdd = paymentDate - currentDayOfWeek.getValue();
      } else {
        // 다음 주 paymentDate(1월 ~ 7일)요일부터 용돈 지급
        daysToAdd = 7 - (currentDayOfWeek.getValue() - paymentDate);
      }
      nextPaymentDate = today.plusDays(daysToAdd);
    }

    this.scheduledDate = nextPaymentDate;
  }

}
