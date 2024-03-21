package org.whalebank.backend.domain.goal.service;

import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.goal.dto.response.GoalResponseDto;

public interface GoalService {

  GoalResponseDto createGoal(GoalRequestDto goalRequest, String loginId);
}
