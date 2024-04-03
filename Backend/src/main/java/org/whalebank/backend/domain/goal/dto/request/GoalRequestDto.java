package org.whalebank.backend.domain.goal.dto.request;

import java.time.LocalDate;
import lombok.Getter;
import lombok.Setter;

@Getter
public class GoalRequestDto {

  public String goal_name; // 목표 이름
  public int goal_amt; // 목표 금액
  public String goal_date;  // 목표 기간
  public String category;  // 저축 카테고리
  public int account_id; // 저축할 통장 아이디

}
