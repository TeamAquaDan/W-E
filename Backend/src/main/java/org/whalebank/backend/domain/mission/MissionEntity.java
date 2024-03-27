package org.whalebank.backend.domain.mission;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.whalebank.backend.domain.allowance.GroupEntity;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Table(name = "mission")
@EnableJpaAuditing
public class MissionEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int mission_id;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "group_id")
  private GroupEntity group;

  private String missionName;

  @ColumnDefault("0")
  private int status; // 0(진행중), 1(성공), 2(실패)

  @CreatedDate
  @Column(updatable = false)
  private LocalDateTime createDtm; // 생성 일시

  private LocalDateTime completeDtm; // 처리 일시

  private int missionReward; // 보상 금액

  private LocalDate deadlineDate; // 마감 일시

}
