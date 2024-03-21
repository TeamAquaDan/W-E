package org.whalebank.backend.domain.account.service;

import java.util.List;
import java.util.Map;
import org.whalebank.backend.domain.account.dto.request.InquiryRequestDto;
import org.whalebank.backend.domain.account.dto.request.TransactionHistoryRequestDto;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;
import org.whalebank.backend.domain.account.dto.response.AccountDetailResponseDto;
import org.whalebank.backend.domain.account.dto.response.AccountInfoResponseDto;
import org.whalebank.backend.domain.account.dto.response.InquiryResponseDto;
import org.whalebank.backend.domain.account.dto.response.TransactionHistoryResponseDto;

public interface AccountService {

  public List<AccountInfoResponseDto> getAllAccounts(String loginId);

  public AccountDetailResponseDto getAccountDetail(String loginId, int accountId);

  public void withdraw(String loginId, WithdrawRequestDto reqDto);

  InquiryResponseDto inquiryReceiver(String loginId, InquiryRequestDto reqDto);

  List<TransactionHistoryResponseDto> getTransactionHistory(String loginId, TransactionHistoryRequestDto reqDto);

  Map<String, Integer> getParkingBalance(String username, Integer accountId);

}
