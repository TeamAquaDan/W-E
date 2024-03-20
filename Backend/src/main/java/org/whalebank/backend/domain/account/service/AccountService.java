package org.whalebank.backend.domain.account.service;

import java.util.List;
import org.whalebank.backend.domain.account.dto.request.InquiryRequestDto;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;
import org.whalebank.backend.domain.account.dto.response.AccountDetailResponseDto;
import org.whalebank.backend.domain.account.dto.response.AccountInfoResponseDto;
import org.whalebank.backend.domain.account.dto.response.InquiryResponseDto;

public interface AccountService {

  public List<AccountInfoResponseDto> getAllAccounts(String loginId);

  public AccountDetailResponseDto getAccountDetail(String loginId, int accountId);

  public void withdraw(String loginId, WithdrawRequestDto reqDto);

  InquiryResponseDto inquiryReceiver(String loginId, InquiryRequestDto reqDto);
}
