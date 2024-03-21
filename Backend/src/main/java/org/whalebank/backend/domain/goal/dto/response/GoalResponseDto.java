package org.whalebank.backend.domain.goal.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class GoalResponseDto {

  private int goal_id;  // 목표 아이디

  private String goal_name; // 목표 이름

  private int goal_amt; // 목표 금액

  private int status; //  0(진행중), 1(성공), 2(실패)

  private String start_date;  // 시작일

  private String goal_date;  // 마감일

  private String withdraw_date; // 출금일

  private int percentage; // 달성률

  private int saved_amt;  // 파킹통장 현재 잔액


}
