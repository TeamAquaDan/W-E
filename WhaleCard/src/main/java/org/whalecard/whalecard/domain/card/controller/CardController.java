package org.whalecard.whalecard.domain.card.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.whalecard.whalecard.domain.card.dto.response.CardResponse;
import org.whalecard.whalecard.domain.card.dto.response.DetailResponse;
import org.whalecard.whalecard.domain.card.service.CardService;

@RestController
@RequestMapping("/whale/card")
@RequiredArgsConstructor
public class CardController {

  private final CardService cardService;

  @GetMapping("/cards")
  public ResponseEntity<CardResponse> getCards(
      HttpServletRequest request) {

    return new ResponseEntity<>(cardService.getCards(request), HttpStatus.OK);
  }

  @GetMapping("/cards/{card_id}")
  public ResponseEntity<DetailResponse> getCard(
      HttpServletRequest request,
      @PathVariable(name = "card_id") int cardId) {

    return new ResponseEntity<>(cardService.getCard(request, cardId), HttpStatus.OK);
  }
}
