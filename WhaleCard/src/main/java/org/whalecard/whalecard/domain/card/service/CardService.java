package org.whalecard.whalecard.domain.card.service;

import jakarta.servlet.http.HttpServletRequest;
import org.whalecard.whalecard.domain.card.dto.response.CardResponse;
import org.whalecard.whalecard.domain.card.dto.response.DetailResponse;

public interface CardService {

  CardResponse getCards(HttpServletRequest request);

  DetailResponse getCard(HttpServletRequest request, int cardId);
}
