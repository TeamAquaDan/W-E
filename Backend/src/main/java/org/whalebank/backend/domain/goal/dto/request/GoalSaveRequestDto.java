package org.whalebank.backend.domain.goal.dto.request;

import lombok.Getter;

@Getter
public class GoalSaveRequestDto {

  public int goal_id; // 저축목표 아이디
  public int save_amt; // 저금 금액

}
