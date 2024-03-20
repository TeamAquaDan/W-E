package org.whalebank.backend.domain.account.service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;
import org.whalebank.backend.domain.account.dto.response.AccountDetailResponseDto;
import org.whalebank.backend.domain.account.dto.response.AccountInfoResponseDto;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.BankAccessUtil;
import org.whalebank.backend.global.openfeign.bank.request.WithdrawRequest;
import org.whalebank.backend.global.openfeign.bank.response.AccountListResponseDto;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

  private final BankAccessUtil bankAccessUtil;
  private final AuthRepository userRepository;

  @Override
  public List<AccountInfoResponseDto> getAllAccounts(String loginId) {
    UserEntity currentUser = getCurrentUser(loginId);

    AccountListResponseDto resFromBank = bankAccessUtil.getAccountInfo(currentUser.getBankAccessToken());
    if(resFromBank.rsp_code.equals("200")) {
      // resFromBank -> List<AccountInfoResponseDto>
      return resFromBank.getAccount_list().stream()
          .map(AccountInfoResponseDto::from)
          .collect(Collectors.toList());
    } else {
      throw new CustomException(ResponseCode.ACCOUNT_NOT_FOUND);
    }
  }

  @Override
  public AccountDetailResponseDto getAccountDetail(String loginId, int accountId) {
    UserEntity currentUser = getCurrentUser(loginId);

    return AccountDetailResponseDto.from(bankAccessUtil.getAccountDetail(currentUser.getBankAccessToken(), accountId));
  }

  @Override
  public void withdraw(String loginId, WithdrawRequestDto reqDto) {
    UserEntity currentUser = getCurrentUser(loginId);
    // 송금인 -> 출금 이체 호출
    bankAccessUtil.withdraw(currentUser.getBankAccessToken(),
        WithdrawRequest.of(currentUser.getUserName(), reqDto));
    // 수신인 -> 입금 이체 호출
  }

  private UserEntity getCurrentUser(String loginId) {
    return userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
  }
}
