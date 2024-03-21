package org.whalebank.backend.domain.goal.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class GoalStatusResponseDto {

  private int status; // 상태

}
