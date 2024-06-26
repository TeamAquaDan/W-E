package org.whalebank.backend.domain.accountbook.service;

import java.util.List;
import org.whalebank.backend.domain.accountbook.dto.request.AccountBookEntryRequestDto;
import org.whalebank.backend.domain.accountbook.dto.response.AccountBookEntryResponseDto;
import org.whalebank.backend.domain.accountbook.dto.response.MonthlyHistoryResponseDto;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.dto.response.StatisticsResponseDto;

public interface AccountBookService {

  public void saveAccountAndCardHistory(UserEntity user);

  public MonthlyHistoryResponseDto getIncomeAndExpenseHistory(String loginId, int year, int month);


  void createAccountBookEntry(String loginId, AccountBookEntryRequestDto request);

  AccountBookEntryResponseDto getAccountBookEntry(int accountBookId, String loginId);

  AccountBookEntryResponseDto updateAccountBookEntry(int accountBookId, AccountBookEntryRequestDto request,  String username);

  void deleteAccountBookEntry(int accountBookId, String loginId);

  StatisticsResponseDto getStatistics(String loginId, int year, int month);
}
