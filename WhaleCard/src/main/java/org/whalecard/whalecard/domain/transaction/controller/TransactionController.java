package org.whalecard.whalecard.domain.transaction.controller;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.whalecard.whalecard.domain.transaction.dto.response.TransactionResponse;
import org.whalecard.whalecard.domain.transaction.service.TransactionService;

@RestController
@RequestMapping("/whale/card")
@RequiredArgsConstructor
public class TransactionController {

  private final TransactionService transactionService;

  @GetMapping("/payments")
  public ResponseEntity<TransactionResponse> getPayments(
      HttpServletRequest request,
      @RequestBody Map<String, LocalDateTime> timestamp) {
    return new ResponseEntity<>(
        transactionService.getPayments(request, timestamp.get("search_timestamp")),
        HttpStatus.OK);
  }

}
