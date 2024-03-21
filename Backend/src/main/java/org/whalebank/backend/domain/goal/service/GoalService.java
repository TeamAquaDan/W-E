package org.whalebank.backend.domain.goal.service;

import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.goal.dto.response.GoalDetailResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalListResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalResponseDto;

public interface GoalService {

  GoalResponseDto createGoal(GoalRequestDto goalRequest, String loginId);

  GoalListResponseDto getGoals(String loginId);


  GoalDetailResponseDto getGoal(String loginId, int goalId);
}
