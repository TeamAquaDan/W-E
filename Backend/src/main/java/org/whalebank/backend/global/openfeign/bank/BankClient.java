package org.whalebank.backend.global.openfeign.bank;

import java.util.Map;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.whalebank.backend.global.config.OpenFeignConfig;
import org.whalebank.backend.global.openfeign.bank.request.CheckUserRequestDto;
import org.whalebank.backend.global.openfeign.bank.response.AccessTokenResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.AccountListResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.CheckUserResponseDto;

@FeignClient(name = "whalebank", url = "http://localhost:58937/whale/bank", configuration = OpenFeignConfig.class)
public interface BankClient {

  @PostMapping("/oauth/2.0/authorize")
  ResponseEntity<CheckUserResponseDto> getUser(@RequestBody CheckUserRequestDto dto);
  
  @PostMapping("/oauth/2.0/token")
  ResponseEntity<AccessTokenResponseDto> generateToken (
    @RequestHeader("x-user-ci") String userCI
  );

  @GetMapping("/accounts")
  ResponseEntity<AccountListResponseDto> getAccountList(
      @RequestHeader("Authorization") String token
  );




}
