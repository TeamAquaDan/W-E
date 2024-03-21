package org.whalebank.backend.global.openfeign.card;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.backend.global.openfeign.bank.request.ReissueRequestDto;
import org.whalebank.backend.global.openfeign.bank.response.AccessTokenResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.ReissueResponseDto;

@Service
@RequiredArgsConstructor
@Slf4j
public class CardAccessUtil {

  private final CardClient cardClient;

  public AccessTokenResponseDto generateToken(String userCI) {
    return cardClient.generateToken(userCI)
        .getBody();
  }

  public ReissueResponseDto reissueToken(String refreshToken) {
    return cardClient.reissueToken(ReissueRequestDto.from(refreshToken))
        .getBody();
  }



}
