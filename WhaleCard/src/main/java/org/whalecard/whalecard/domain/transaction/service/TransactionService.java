package org.whalecard.whalecard.domain.transaction.service;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import org.whalecard.whalecard.domain.transaction.dto.response.TransactionResponse;

public interface TransactionService {

  TransactionResponse getPayments(HttpServletRequest request, LocalDateTime searchTimestamp);
}
