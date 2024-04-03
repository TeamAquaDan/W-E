package org.whalebank.backend.domain.goal.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class GoalSaveResponseDto {

  private int saved_amt; // 파킹통장 현재 잔액

}
