package org.whalebank.backend.domain.goal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
import lombok.Setter;
import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.user.UserEntity;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "goal")
public class GoalEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "goal_id")
  private int goalID;

  private String goalName;  // 목표 이름

  private int goalAmt;  // 목표 금액

  private LocalDate goalDate; // 목표 날짜

  private LocalDate startDate;  // 시작날짜

  private LocalDate withdrawDate; // 출금/포기하기 누른 날짜

  private int withdrawAmt;  // 출금한 금액

  private int status; // PROCEEDING(0),  SUCCESS(1), FAIL(2)

  private String category;  // 저축 카테고리

  private int accountId;  // 저축목표 연동 계좌

  @ManyToOne
  @JoinColumn(name = "user_id")
  private UserEntity user;

  public static GoalEntity createGoal(GoalRequestDto goalRequest, UserEntity user,
      LocalDate today) {

    return GoalEntity
        .builder()
        .goalName(goalRequest.getGoal_name())
        .goalAmt(goalRequest.getGoal_amt())
        .startDate(today)
        .goalDate(LocalDate.parse(goalRequest.getGoal_date()))
        .status(0)
        .category(goalRequest.getCategory())
        .accountId(goalRequest.getAccount_id())
        .user(user)
        .build();
  }


}
