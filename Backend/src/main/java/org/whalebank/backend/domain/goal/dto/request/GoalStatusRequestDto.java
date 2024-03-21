package org.whalebank.backend.domain.goal.dto.request;

import lombok.Getter;

@Getter
public class GoalStatusRequestDto {

  private int goal_id;  // 저축목표 아이디
  private int status; // 상태

}
