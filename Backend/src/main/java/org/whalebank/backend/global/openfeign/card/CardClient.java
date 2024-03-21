package org.whalebank.backend.global.openfeign.card;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.whalebank.backend.global.config.OpenFeignConfig;
import org.whalebank.backend.global.openfeign.bank.request.ReissueRequestDto;
import org.whalebank.backend.global.openfeign.bank.response.AccessTokenResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.ReissueResponseDto;

@FeignClient(name = "whalecard", url = "${whale.card.url}/whale/card", configuration = OpenFeignConfig.class)
public interface CardClient {

  @PostMapping("/oauth/2.0/token")
  ResponseEntity<AccessTokenResponseDto> generateToken (
      @RequestHeader("x-user-ci") String userCI
  );

  @PostMapping("/oauth/2.0/reissue")
  ResponseEntity<ReissueResponseDto> reissueToken (
      @RequestBody ReissueRequestDto requestDto
  );

}
