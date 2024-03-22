package org.whalebank.backend.global.openfeign.card;


import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.backend.global.openfeign.bank.request.ReissueRequestDto;
import org.whalebank.backend.global.openfeign.bank.response.AccessTokenResponseDto;
import org.whalebank.backend.global.openfeign.bank.response.ReissueResponseDto;
import org.whalebank.backend.global.openfeign.card.request.CardHistoryRequest;
import org.whalebank.backend.global.openfeign.card.response.CardHistoryResponse;

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

  public CardHistoryResponse getCardHistory(String accessToken, LocalDateTime lastCardHistoryFetchTime) {
    return cardClient.getCardList(accessToken, CardHistoryRequest.from(lastCardHistoryFetchTime))
        .getBody();
  }

}
