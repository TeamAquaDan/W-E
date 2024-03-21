package org.whalebank.backend.global.openfeign.bank;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.whalebank.backend.global.config.OpenFeignConfig;
import org.whalebank.backend.global.openfeign.bank.request.AccountIdRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.CheckUserRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.DepositRequest;
import org.whalebank.backend.global.openfeign.bank.request.InquiryRequest;
import org.whalebank.backend.global.openfeign.bank.request.ParkingRequest;
import org.whalebank.backend.global.openfeign.bank.request.ReissueRequestDto;
import org.whalebank.backend.global.openfeign.bank.request.TransactionRequest;
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
import org.whalebank.backend.global.openfeign.bank.response.WithdrawResponse;

@FeignClient(name = "whalebank", url = "http://localhost:58937/whale/bank", configuration = OpenFeignConfig.class)
public interface BankClient {

  @PostMapping("/oauth/2.0/authorize")
  ResponseEntity<CheckUserResponseDto> getUser(@RequestBody CheckUserRequestDto dto);

  @PostMapping("/oauth/2.0/token")
  ResponseEntity<AccessTokenResponseDto> generateToken (
    @RequestHeader("x-user-ci") String userCI
  );

  @PostMapping("/oauth/2.0/reissue")
  ResponseEntity<ReissueResponseDto> reissueToken (
      @RequestBody ReissueRequestDto requestDto
  );

  // 계좌 목록 조회
  @GetMapping("/accounts")
  ResponseEntity<AccountListResponseDto> getAccountList(
      @RequestHeader("Authorization") String token
  );

  // 수신계좌 추가정보 조회
  @PostMapping("/accounts/deposit/detail")
  ResponseEntity<AccountDetailResponse> getAccountDetail(
      @RequestHeader("Authorization") String token,
      @RequestBody AccountIdRequestDto requestDto
  );

  // 출금이체
  @PostMapping("/transfer/withdraw")
  ResponseEntity<WithdrawResponse> withdraw(
      @RequestHeader("Authorization") String token,
      @RequestBody WithdrawRequest requestDto
  );

  // 입금이체
  @PostMapping("/transfer/deposit")
  ResponseEntity<DepositResponse> deposit(
      @RequestHeader("Authorization") String token,
      @RequestBody DepositRequest requestDto
  );

  // 수취조회
  @PostMapping("/inquiry/receive")
  ResponseEntity<InquiryResponse> inquiry(
      @RequestHeader("Authorization") String token,
      @RequestBody InquiryRequest request
  );

  // 수신계좌 거래내역 조회
  @PostMapping("/accounts/deposit/transactions")
  ResponseEntity<TransactionResponse> getTransaction(
      @RequestHeader("Authorization") String token,
      @RequestBody TransactionRequest request
  );


  // 파킹통장 저금
  @PatchMapping("/accounts/parking/deposit")
  ResponseEntity<ParkingBalanceResponse> depositParking(
      @RequestHeader("Authorization") String token,
      @RequestBody ParkingRequest request
  );

  // 파킹통장 출금
  @PatchMapping("/accounts/parking/withdraw")
  ResponseEntity<ParkingBalanceResponse> withdrawParking(
      @RequestHeader("Authorization") String token,
      @RequestBody ParkingRequest request
  );

  // 파킹통장 잔액 조회
  @PostMapping("/accounts/parking")
  ResponseEntity<ParkingBalanceResponse> getParking(
      @RequestHeader("Authorization") String token,
      @RequestBody AccountIdRequestDto request
  );

}
