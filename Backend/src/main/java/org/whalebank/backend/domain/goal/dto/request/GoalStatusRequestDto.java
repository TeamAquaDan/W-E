package org.whalebank.backend.domain.goal.dto.request;

import lombok.Getter;

@Getter
public class GoalStatusRequestDto {

  public int goal_id;  // 저축목표 아이디
  public int status; // 상태

}
