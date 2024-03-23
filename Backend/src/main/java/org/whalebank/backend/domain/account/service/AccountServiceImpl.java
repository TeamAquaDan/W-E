package org.whalebank.backend.domain.account.service;

import jakarta.transaction.Transactional;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.account.dto.request.InquiryRequestDto;
import org.whalebank.backend.domain.account.dto.request.TransactionHistoryRequestDto;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;
import org.whalebank.backend.domain.account.dto.response.AccountDetailResponseDto;
import org.whalebank.backend.domain.account.dto.response.AccountInfoResponseDto;
import org.whalebank.backend.domain.account.dto.response.InquiryResponseDto;
import org.whalebank.backend.domain.account.dto.response.TransactionHistoryResponseDto;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.BankAccessUtil;
import org.whalebank.backend.global.openfeign.bank.request.AccountIdRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.DepositRequest;
import org.whalebank.backend.global.openfeign.bank.request.InquiryRequest;
import org.whalebank.backend.global.openfeign.bank.request.TransactionRequest;
import org.whalebank.backend.global.openfeign.bank.request.WithdrawRequest;
import org.whalebank.backend.global.openfeign.bank.response.AccountListResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.InquiryResponse;
import org.whalebank.backend.global.openfeign.bank.response.ParkingBalanceResponse;
import org.whalebank.backend.global.openfeign.bank.response.TransactionResponse;
import org.whalebank.backend.global.openfeign.bank.response.WithdrawResponse;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

  private final BankAccessUtil bankAccessUtil;
  private final AuthRepository userRepository;

  @Override
  public List<AccountInfoResponseDto> getAllAccounts(String loginId) {
    UserEntity currentUser = getCurrentUser(loginId);

    AccountListResponseDto resFromBank = bankAccessUtil.getAccountInfo(
        currentUser.getBankAccessToken());

    // resFromBank -> List<AccountInfoResponseDto>
    return resFromBank.getAccount_list().stream()
        .map(AccountInfoResponseDto::from)
        .collect(Collectors.toList());

  }

  @Override
  public AccountDetailResponseDto getAccountDetail(String loginId, int accountId) {
    UserEntity currentUser = getCurrentUser(loginId);

    return AccountDetailResponseDto.from(bankAccessUtil.getAccountDetail(currentUser.getBankAccessToken(), accountId));
  }

  @Override
  public InquiryResponseDto inquiryReceiver(String loginId, InquiryRequestDto reqDto) {
    UserEntity user = getCurrentUser(loginId);

    InquiryResponse resFromBank = bankAccessUtil.inquiry(user.getBankAccessToken(),
        InquiryRequest.from(reqDto));

    return InquiryResponseDto.from(resFromBank);
  }

  @Override
  @Transactional
  public void withdraw(String loginId, WithdrawRequestDto reqDto) {
    UserEntity currentUser = getCurrentUser(loginId);
    // 송금인 -> 출금 이체 호출
    WithdrawResponse res = bankAccessUtil.withdraw(currentUser.getBankAccessToken(),
        WithdrawRequest.of(currentUser.getUserName(), reqDto));
    // 수신인 -> 입금 이체 호출
    bankAccessUtil.deposit(currentUser.getBankAccessToken(),
        DepositRequest.of(currentUser.getUserName(), reqDto, res));
  }

  @Override
  public List<TransactionHistoryResponseDto> getTransactionHistory(String loginId,
      TransactionHistoryRequestDto reqDto) {
    UserEntity currentUser = getCurrentUser(loginId);
    TransactionResponse resFromBank = bankAccessUtil.getTransactionHistory(
        currentUser.getBankAccessToken(), TransactionRequest.from(reqDto));

    return resFromBank.getTrans_list().stream()
        .map(TransactionHistoryResponseDto::from)
        .collect(Collectors.toList());
  }


  @Override
  public Map<String, Integer> getParkingBalance(String username, Integer accountId) {
    UserEntity loginUser = getCurrentUser(username);

    ParkingBalanceResponse res = bankAccessUtil.getParkingBalance(loginUser.getBankAccessToken(),
        new AccountIdRequestDto(accountId));
    Map<String, Integer> balanceAmt = new HashMap<>();
    balanceAmt.put("parking_amt", res.getParking_balance_amt());
    return balanceAmt;
  }

  private UserEntity getCurrentUser(String loginId) {
    return userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
  }
}
