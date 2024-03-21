package org.whalebank.backend.domain.goal.dto.request;

import java.time.LocalDate;
import lombok.Getter;
import lombok.Setter;

@Getter
public class GoalRequestDto {

  private String goal_name; // 목표 이름
  private int goal_amt; // 목표 금액
  private String goal_date;  // 목표 기간
  private String category;  // 저축 카테고리
  private int account_id; // 저축할 통장 아이디

}
