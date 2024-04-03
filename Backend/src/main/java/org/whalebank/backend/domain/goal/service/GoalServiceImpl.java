package org.whalebank.backend.domain.goal.service;

import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.goal.GoalEntity;
import org.whalebank.backend.domain.goal.dto.request.GoalRequestDto;
import org.whalebank.backend.domain.goal.dto.request.GoalSaveRequestDto;
import org.whalebank.backend.domain.goal.dto.request.GoalStatusRequestDto;
import org.whalebank.backend.domain.goal.dto.response.GoalDetailResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalListResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalListResponseDto.Goal;
import org.whalebank.backend.domain.goal.dto.response.GoalResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalSaveResponseDto;
import org.whalebank.backend.domain.goal.dto.response.GoalStatusResponseDto;
import org.whalebank.backend.domain.goal.repository.GoalRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.BankAccessUtil;
import org.whalebank.backend.global.openfeign.bank.request.AccountIdRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.ParkingRequest;
import org.whalebank.backend.global.openfeign.bank.response.ParkingBalanceResponse;
import org.whalebank.backend.global.response.ResponseCode;

@RequiredArgsConstructor
@Service
public class GoalServiceImpl implements GoalService {

  private final AuthRepository authRepository;
  private final GoalRepository goalRepository;
  private final BankAccessUtil bankAccessUtil;

  @Override
  public GoalResponseDto createGoal(GoalRequestDto goalRequest, String loginId) {

    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 이미 목표가 진행 중인 계좌면 에러
    GoalEntity existingGoal = goalRepository.findByAccountIdAndStatus(goalRequest.getAccount_id(),
        0);
    if (existingGoal != null) {
      throw new CustomException(ResponseCode.ALREADY_EXIST);
    }

    // 파킹통장 잔액
    ParkingBalanceResponse parkingBalance = bankAccessUtil.getParkingBalance(
        user.getBankAccessToken(),
        new AccountIdRequestDto(goalRequest.getAccount_id()));

    // 새로운 목표 생성
    GoalEntity goal = GoalEntity.createGoal(goalRequest, user, LocalDate.now());

    // 목표 저장
    goalRepository.save(goal);

    // 해당하는 유저에 목표 등록
    user.addGoal(goal);

    // 사용자를 저장
    authRepository.save(user);

    return GoalResponseDto
        .builder()
        .goal_id(goal.getGoalID())
        .goal_name(goal.getGoalName())
        .goal_amt(goal.getGoalAmt())
        .status(goal.getStatus())
        .start_date(String.valueOf(goal.getStartDate()))
        .goal_date(String.valueOf(goal.getGoalDate()))
        .percentage(0)
        .saved_amt(parkingBalance.getParking_balance_amt())
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
          ParkingBalanceResponse parkingBalance = bankAccessUtil.getParkingBalance(
              user.getBankAccessToken(), AccountIdRequestDto.create(g.getAccountId()));

          double savedAmt = parkingBalance.getParking_balance_amt() * 1.0;

          double percentage = savedAmt / g.getGoalAmt() * 100;

          return new Goal(
              g.getGoalID(),
              g.getGoalName(),
              g.getGoalAmt(),
              g.getStatus(),
              g.getStartDate().toString(),
              withdrawDate,
              g.getGoalDate().toString(),
              percentage,
              g.getWithdrawAmt(),
              g.getCategory(),
              parkingBalance.getParking_balance_amt()
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

    double savedAmt = parkingBalance.getParking_balance_amt() * 1.0;

    double percentage = savedAmt / goal.getGoalAmt() * 100;

    return GoalDetailResponseDto
        .builder()
        .goal_id(goalId)
        .goal_name(goal.getGoalName())
        .goal_amt(goal.getGoalAmt())
        .status(goal.getStatus())
        .start_date(String.valueOf(goal.getStartDate()))
        .goal_date(String.valueOf(goal.getGoalDate()))
        .percentage(percentage)
        .saved_amt((int) savedAmt)
        .category(goal.getCategory())
        .build();
  }

  @Override
  public GoalSaveResponseDto saveMoney(GoalSaveRequestDto saveRequest, String loginId) {

    // 로그인 유저
    UserEntity user = authRepository.findByLoginId(loginId).get();

    GoalEntity goal = goalRepository.getById(String.valueOf(saveRequest.getGoal_id()));

    // 파킹통장에 저금
    ParkingBalanceResponse depositParking = bankAccessUtil.depositParking(
        user.getBankAccessToken(),
        new ParkingRequest(goal.getAccountId(), saveRequest.getSave_amt()));

    return GoalSaveResponseDto
        .builder()
        .saved_amt(depositParking.getParking_balance_amt())
        .build();
  }

  @Override
  public GoalStatusResponseDto updateStatus(GoalStatusRequestDto statusRequest, String loginId) {

    // 로그인 유저
    UserEntity user = authRepository.findByLoginId(loginId).get();

    GoalEntity goal = goalRepository.getById(String.valueOf(statusRequest.getGoal_id()));

    // 파킹통장 잔액
    ParkingBalanceResponse parkingBalance = bankAccessUtil.getParkingBalance(
        user.getBankAccessToken(),
        new AccountIdRequestDto(goal.getAccountId()));

    // status 변경
    goal.setStatus(statusRequest.getStatus());
    // 종료 날짜 저장
    goal.setWithdrawDate(LocalDate.now());
    // 출금 금액 저장
    goal.setWithdrawAmt(parkingBalance.getParking_balance_amt());

    goalRepository.save(goal);

    // 파킹통장 전액 출금
    ParkingBalanceResponse withdrawParking = bankAccessUtil.withdrawParking(
        user.getBankAccessToken(),
        new ParkingRequest(goal.getAccountId(), parkingBalance.getParking_balance_amt()));

    return GoalStatusResponseDto
        .builder()
        .status(statusRequest.getStatus())
        .build();
  }
}