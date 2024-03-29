package org.whalebank.backend.domain.negotiation;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EnableJpaAuditing
@Table(name = "negotiation")
public class NegotiationEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int negoId;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "group_id")
  private GroupEntity group;

  private int negoAmt;

  private String negoReason; // 요청 사유

  private String negoComment; // 요청 승인/거절 사유

  @ColumnDefault("0")
  private int status; // 처리 상태 0(대기중) 1(승인) 2(거절)

  @CreationTimestamp
  private LocalDateTime createDtm = LocalDateTime.now(); // 요청 일시

  private LocalDateTime completedDtm;// 처리 일시

  private int currentAllowanceAmt; // 요청 당시 용돈 금액

  public void setGroup(GroupEntity group) {
    this.group = group;
  }

  public static NegotiationEntity of(GroupEntity group, NegoRequestDto reqDto,
      int currentAllowanceAmt) {
    return NegotiationEntity.builder()
        .group(group)
        .negoAmt(reqDto.getNego_amt())
        .negoReason(reqDto.getNego_reason())
        .currentAllowanceAmt(currentAllowanceAmt)
        .build();

  }

  public void manageNegotiation(String comment, int status) {
    this.completedDtm = LocalDateTime.now();
    this.negoComment = comment;
    this.status = status;
  }

}
