package org.whalecard.whalecard.domain.card.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.Token;
import org.springframework.stereotype.Service;
import org.whalecard.whalecard.domain.auth.repository.AuthRepository;
import org.whalecard.whalecard.domain.auth.security.TokenProvider;
import org.whalecard.whalecard.domain.card.CardEntity;
import org.whalecard.whalecard.domain.card.dto.response.CardResponse;
import org.whalecard.whalecard.domain.card.dto.response.CardResponse.Card;
import org.whalecard.whalecard.domain.card.dto.response.DetailResponse;
import org.whalecard.whalecard.domain.card.repository.CardRepository;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class CardServiceImpl implements CardService {

  private final TokenProvider tokenProvider;
  private final AuthRepository authRepository;
  private final CardRepository cardRepository;

  @Override
  public CardResponse getCards(HttpServletRequest request) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    if (authRepository.findById(userId).get().getCardList() == null) {
      return CardResponse
          .builder()
          .rsp_code(404)
          .rsp_message("카드가 존재하지 않습니다")
          .build();
    }

    List<CardEntity> findCards = authRepository.findById(userId).get().getCardList();

    List<Card> cards = findCards.stream()
        .map(a -> new Card(a.getCardId(), a.getCardNo(), a.getCardName()))
        .collect(Collectors.toList());

    return CardResponse
        .builder()
        .rsp_code(200)
        .rsp_message("카드 목록 조회 성공")
        .card_cnt(findCards.size())
        .card_list(cards)
        .build();
  }

  @Override
  public DetailResponse getCard(HttpServletRequest request, int cardId) {
    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    Optional<CardEntity> card = cardRepository.findById(String.valueOf(cardId));

    if (card == null) {
      return DetailResponse
          .builder()
          .rsp_code(404)
          .rsp_message("카드를 찾을 수 없습니다.")
          .build();
    }

    return DetailResponse
        .builder()
        .rsp_code(200)
        .rsp_message("카드 조회 성공")
        .card_id(cardId)
        .card_no(card.get().getCardNo())
        .card_name(card.get().getCardName())
        .account_num(card.get().getAccountNum())
        .issue_date(card.get().getIssueDate())
        .end_date(card.get().getEndDate())
        .build();
  }
}
