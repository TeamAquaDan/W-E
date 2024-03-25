package org.whalebank.backend.domain.accountbook.service;

import java.util.List;
import org.whalebank.backend.domain.accountbook.dto.request.AccountBookEntryRequestDto;
import org.whalebank.backend.domain.accountbook.dto.response.AccountBookEntryResponse;
import org.whalebank.backend.domain.accountbook.dto.response.MonthlyHistoryResponseDto;
import org.whalebank.backend.domain.user.UserEntity;

public interface AccountBookService {

  public void saveAccountAndCardHistory(UserEntity user);

  public MonthlyHistoryResponseDto getIncomeAndExpenseHistory(String loginId, int year, int month);


  void createAccountBookEntry(String loginId, AccountBookEntryRequestDto request);

  AccountBookEntryResponse getAccountBookEntry(int accountBookId, String loginId);
}
