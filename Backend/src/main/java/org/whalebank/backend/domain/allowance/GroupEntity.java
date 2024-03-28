package org.whalebank.backend.domain.allowance;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.whalebank.backend.domain.allowance.dto.request.AddGroupRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateAllowanceRequestDto;

@Entity
@Table(name = "we_group")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class GroupEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int groupId;

  private boolean isMonthly;

  private int allowanceAmt;

  private int dayOfMonth;

  private int dayOfWeek;

  @CreatedDate
  @Column(updatable = false)
  private LocalDate createdDtm;

  @OneToMany(mappedBy = "userGroup", cascade = CascadeType.ALL)
  List<RoleEntity> memberEntityList = new ArrayList<>();

  @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
  @JoinColumn(name = "auto_payment_id")
  AutoPaymentEntity autoPaymentEntity;

  public static GroupEntity from(AddGroupRequestDto reqDto) {
    return GroupEntity.builder()
        .memberEntityList(new ArrayList<>())
        .isMonthly(reqDto.is_monthly)
        .allowanceAmt(reqDto.getAllowance_amt())
        .dayOfMonth(reqDto.is_monthly ? reqDto.getPayment_date() : 0) // isMonthly가 true인 경우에만 dayOfMonth 설정
        .dayOfWeek(reqDto.is_monthly ? 0 : reqDto.getPayment_date()) // isMonthly가 false인 경우에만 dayOfWeek 설정
        .build();
  }

  public void updateGroup(UpdateAllowanceRequestDto reqDto) {
    this.isMonthly = reqDto.getIs_monthly();
    this.allowanceAmt = reqDto.getAllowance_amt();
    this.dayOfMonth = isMonthly ? reqDto.payment_date : 0;
    this.dayOfWeek = isMonthly ? 0:reqDto.payment_date;
  }

  public void addRole(RoleEntity role) {
    this.memberEntityList.add(role);
    role.setGroup(this);
  }

  public void setAutoPaymentEntity(AutoPaymentEntity entity) {
    this.autoPaymentEntity = entity;
  }

}
