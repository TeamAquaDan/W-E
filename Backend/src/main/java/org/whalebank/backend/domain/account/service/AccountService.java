package org.whalebank.backend.domain.account.service;

import java.util.List;
import org.whalebank.backend.domain.account.dto.response.AccountDetailResponseDto;
import org.whalebank.backend.domain.account.dto.response.AccountInfoResponseDto;

public interface AccountService {

  public List<AccountInfoResponseDto> getAllAccounts(String loginId);

  public AccountDetailResponseDto getAccountDetail(String loginId, int accountId);

}
