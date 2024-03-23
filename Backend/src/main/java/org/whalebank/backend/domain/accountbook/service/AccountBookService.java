package org.whalebank.backend.domain.accountbook.service;

import java.time.LocalDateTime;
import java.util.List;
import org.whalebank.backend.domain.accountbook.dto.response.CardHistoryResponseDto;
import org.whalebank.backend.domain.user.UserEntity;

public interface AccountBookService {

  public void saveAccountAndCardHistory(UserEntity user);

  public List<CardHistoryResponseDto> getIncomeAndExpenseHistory(String loginId, int year, int month);



}
