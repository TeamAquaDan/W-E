package org.whalebank.backend.global.openfeign.bank;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.request.AccountIdRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.CheckUserRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.DepositRequest;
import org.whalebank.backend.global.openfeign.bank.request.InquiryRequest;
import org.whalebank.backend.global.openfeign.bank.request.ParkingRequest;
import org.whalebank.backend.global.openfeign.bank.request.ReissueRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.TransactionRequest;
import org.whalebank.backend.global.openfeign.bank.request.VerifyRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.WithdrawRequest;
import org.whalebank.backend.global.openfeign.bank.response.AccessTokenResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.AccountDetailResponse;
import org.whalebank.backend.global.openfeign.bank.response.AccountListResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.CheckUserResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.DepositResponse;
import org.whalebank.backend.global.openfeign.bank.response.InquiryResponse;
import org.whalebank.backend.global.openfeign.bank.response.ParkingBalanceResponse;
import org.whalebank.backend.global.openfeign.bank.response.ReissueResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.TransactionResponse;
import org.whalebank.backend.global.openfeign.bank.response.VerifyResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.WithdrawResponse;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
@Slf4j
public class BankAccessUtil {

  private final BankClient bankClient;

  public AccountListResponseDto getAccountInfo(String bankAccessToken) {
    return bankClient.getAccountList(
        "Bearer " + bankAccessToken
    ).getBody();

  }

  public AccountDetailResponse getAccountDetail(String bankAccountToken, int accountId) {
    try {
      AccountDetailResponse res = bankClient.getAccountDetail(bankAccountToken,
              new AccountIdRequestDto(accountId))
          .getBody();
      return res;
    } catch(Exception e) {
      throw new CustomException(ResponseCode.ACCOUNT_NOT_FOUND);
    }
  }

  // 출금이체
  public WithdrawResponse withdraw(String bankAccessToken, WithdrawRequest req) {
    WithdrawResponse res = bankClient.withdraw(bankAccessToken, req
    ).getBody();

    if(res.getRsp_code()==401) {
      throw new CustomException(ResponseCode.WRONG_ACCOUNT_PASSWORD);
    } else if(res.getRsp_code()==402) {
      throw new CustomException(ResponseCode.INSUFFICIENT_BALANCE);
    } else if(res.getRsp_code()==403) {
      throw new CustomException(ResponseCode.TRANSFER_LIMIT_EXCEEDED);
    }
    return res;
  }

  // 입금이체
  public DepositResponse deposit(String bankAccessToken, DepositRequest req) {
    return bankClient.deposit(bankAccessToken, req)
        .getBody();
  }

  // 수취인조회
  public InquiryResponse inquiry(String bankAccessToken, InquiryRequest req) {
    InquiryResponse res = bankClient.inquiry(bankAccessToken, req)
        .getBody();

    if(res.getRsp_code()==404) {
      throw new CustomException(ResponseCode.ACCOUNT_NOT_FOUND);
    }
    return res;
  }

  // 수신계좌 거래내역 조회
  public TransactionResponse getTransactionHistory(String bankAccessToken, TransactionRequest request) {
    TransactionResponse res = bankClient.getTransaction(bankAccessToken, request)
        .getBody();

    if(res.getRsp_code()==404) {
      throw new CustomException(ResponseCode.ACCOUNT_NOT_FOUND);
    }
    return res;
  }

  /**
   *
   * @param userCI
   * @return 은행에 userCI값을 가진 유저가 존재한다면 은행에서 전화번호를 받아옴
   */
  public String getUserInfo(String userCI) {
    CheckUserResponseDto userResponseDto = bankClient.getUser(new CheckUserRequestDto(userCI))
        .getBody();


    if(userResponseDto == null) {
      // 은행에 유저가 존재하지 않음
      throw new CustomException(ResponseCode.BANK_USER_NOT_FOUND);
    } else {
      log.info(userResponseDto.getPhone_num());
    }

    return userResponseDto.getPhone_num();
  }

  public AccessTokenResponseDto generateToken(String userCI) {
    return bankClient.generateToken(userCI)
        .getBody();
  }

  public ReissueResponseDto reissueToken(String refreshToken) {
    return bankClient.reissueToken(ReissueRequestDto.from(refreshToken))
        .getBody();
  }

  // 파킹통장 저금
  public ParkingBalanceResponse depositParking(String token, ParkingRequest request) {
    ParkingBalanceResponse res = bankClient.depositParking(token, request)
        .getBody();
    if(res.getRsp_code()==404) {
      throw new CustomException(ResponseCode.ACCOUNT_NOT_FOUND);
    } else if(res.getRsp_code()==402) { // 잔액 부족
      throw new CustomException(ResponseCode.INSUFFICIENT_BALANCE);
    }
    return res;
  }

  // 파킹통장 출금
  public ParkingBalanceResponse withdrawParking(String token, ParkingRequest request) {
    ParkingBalanceResponse res = bankClient.withdrawParking(token, request)
        .getBody();
    if(res.getRsp_code()==404) {
      throw new CustomException(ResponseCode.ACCOUNT_NOT_FOUND);
    }
    return res;
  }

  // 파킹통장 잔액 조회
  public ParkingBalanceResponse getParkingBalance(String token, AccountIdRequestDto request) {
    ParkingBalanceResponse res = bankClient.getParking(token, request)
        .getBody();
    if(res.getRsp_code()==404) {
      throw new CustomException(ResponseCode.ACCOUNT_NOT_FOUND);
    }
    return res;
  }

  public boolean verifyAccountPassword(String token, int accountId, String accountPassword) {
    VerifyResponseDto res = bankClient.verifyAccountPassword(token,
            VerifyRequestDto.of(accountId, accountPassword))
        .getBody();

    if (res.rsp_code == 200) {
      return true;
    } else if (res.rsp_code == 401) {
      throw new CustomException(ResponseCode.WRONG_ACCOUNT_PASSWORD);
    } else {
      throw new CustomException(ResponseCode.INTERNAL_SERVER_ERROR);
    }
  }

}
