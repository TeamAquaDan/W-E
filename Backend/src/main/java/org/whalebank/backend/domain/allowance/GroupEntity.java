package org.whalebank.backend.domain.allowance;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;

@Entity
@Table(name = "group")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GroupEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int groupId;

  @OneToMany(mappedBy = "group")
  private List<RoleEntity> role = new ArrayList<>();

  private boolean isMonthly;

  private int allowanceAmt;

  private byte dayOfMonth;

  private byte dayOfWeek;

  @CreatedDate
  @Column(updatable = false)
  private LocalDate createdDtm;

}
