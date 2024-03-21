package org.whalebank.backend.domain.goal.service;

import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.goal.GoalEntity;
import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.goal.dto.response.GoalDetailResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalListResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalListResponseDto.Goal;
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
    ParkingBalanceResponse parkingBalance = bankAccessUtil.getParkingBalance(
        user.getBankAccessToken(),
        new AccountIdRequestDto(goalRequest.getAccount_id()));

    // 새로운 목표 생성
    GoalEntity goal = GoalEntity.createGoal(goalRequest, user, LocalDate.now());

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

  @Override
  public GoalListResponseDto getGoals(String loginId) {

    // 로그인 유저
    UserEntity user = authRepository.findByLoginId(loginId).get();

    // 사용자가 등록한 모든 목표
    List<GoalEntity> findGoals = authRepository.findById(user.getUserId()).get().getGoalList();

    // 달성률 : (출금한 금액 / 목표 금액) * 100

    List<Goal> goals = findGoals.stream()
        .map(g -> {
          String withdrawDate =
              g.getWithdrawDate() != null ? g.getWithdrawDate().toString() : null;
          return new Goal(
              g.getGoalID(),
              g.getGoalName(),
              g.getGoalAmt(),
              g.getStatus(),
              g.getStartDate().toString(),
              withdrawDate,
              g.getGoalDate().toString(),
              (g.getWithdrawAmt() / g.getGoalAmt()) * 100,
              g.getWithdrawAmt()
          );
        })
        .toList();

    return GoalListResponseDto
        .builder()
        .goal_list(goals)
        .build();
  }

  @Override
  public GoalDetailResponseDto getGoal(String loginId, int goalId) {

    // 로그인 유저
    UserEntity user = authRepository.findByLoginId(loginId).get();

    GoalEntity goal = goalRepository.getById(String.valueOf(goalId));

    // 파킹통장 잔액
    ParkingBalanceResponse parkingBalance = bankAccessUtil.getParkingBalance(
        user.getBankAccessToken(),
        new AccountIdRequestDto(goal.getAccountId()));

    int savedAmt = parkingBalance.getParking_balance_amt();

    int percentage = savedAmt / goal.getGoalAmt() * 100;

    return GoalDetailResponseDto
        .builder()
        .goal_id(goalId)
        .goal_name(goal.getGoalName())
        .goal_amt(goal.getGoalAmt())
        .status(goal.getStatus())
        .start_date(String.valueOf(goal.getStartDate()))
        .goal_date(String.valueOf(goal.getGoalDate()))
        .percentage(percentage)
        .saved_amt(savedAmt)
        .build();
  }

}