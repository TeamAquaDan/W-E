package org.whalebank.backend.domain.goal.service;

import java.time.LocalDate;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.goal.GoalEntity;
import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.goal.dto.response.GoalResponseDto;
import org.whalebank.backend.domain.goal.repository.GoalRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.openfeign.bank.BankAccessUtil;
import org.whalebank.backend.global.openfeign.bank.request.AccountIdRequestDto;
import org.whalebank.backend.global.openfeign.bank.response.ParkingBalanceResponse;

@RequiredArgsConstructor
@Service
public class GoalServiceImpl implements GoalService {

  private final AuthRepository authRepository;
  private final GoalRepository goalRepository;
  private final BankAccessUtil bankAccessUtil;

  @Override
  public GoalResponseDto createGoal(GoalRequestDto goalRequest, String loginId) {

    // 로그인 유저
    UserEntity user = authRepository.findByLoginId(loginId).get();

    // 파킹통장 잔액
    ParkingBalanceResponse parkingBalance = bankAccessUtil.getParkingBalance(user.getBankAccessToken(),
        new AccountIdRequestDto(goalRequest.getAccount_id()));

    // 새로운 목표 생성
    GoalEntity goal = GoalEntity.createGoal(goalRequest, LocalDate.now());

    goalRepository.save(goal);

    // 해당하는 유저에 목표 등록
    user.addGoal(goal);

    return GoalResponseDto
        .builder()
        .goal_id(goal.getGoalID())
        .goal_name(goal.getGoalName())
        .goal_amt(goal.getGoalAmt())
        .status(goal.getStatus())
        .start_date(String.valueOf(goal.getStartDate()))
        .goal_date(String.valueOf(goal.getGoalDate()))
        .percentage(parkingBalance.getParking_balance_amt())
        .build();
  }
}
