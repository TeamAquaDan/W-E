package org.whalecard.whalecard.domain.transaction.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalecard.whalecard.domain.auth.AuthEntity;
import org.whalecard.whalecard.domain.auth.repository.AuthRepository;
import org.whalecard.whalecard.domain.auth.security.TokenProvider;
import org.whalecard.whalecard.domain.card.CardEntity;
import org.whalecard.whalecard.domain.card.repository.CardRepository;
import org.whalecard.whalecard.domain.transaction.TransactionEntity;
import org.whalecard.whalecard.domain.transaction.dto.response.TransactionResponse;
import org.whalecard.whalecard.domain.transaction.repository.TransactionRepository;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class TransactionServiceImpl implements TransactionService {

  private final TokenProvider tokenProvider;
  private final CardRepository cardRepository;
  private final AuthRepository authRepository;

  @Override
  public TransactionResponse getPayments(HttpServletRequest request,
      LocalDateTime searchTimestamp) {

    String token = request.getHeader("Authorization").replace("Bearer ", "");

    String userId = tokenProvider.getUserId(token).get("sub", String.class);

    LocalDateTime lastSearch = searchTimestamp;

    // 결과로 돌려줄 거래내역 리스트
    List<TransactionResponse.Transaction> transactions = new ArrayList<>();

    // 사용자
    AuthEntity user = authRepository.getById(userId);

    // 사용자에 해당하는 카드리스트
    List<CardEntity> cardList = user.getCardList();

    for (CardEntity card : cardList) {

      List<TransactionEntity> findTransactions = card.getTransactionList();


      // 최종시각 이후로 결제된 내역을 리스트에 추가한다.
      List<TransactionResponse.Transaction> cardTransactions  = findTransactions.stream()
          .filter(t -> t.getTransactionDtm().isAfter(lastSearch))
          .map(t -> new TransactionResponse.Transaction(t.getTransId(), card.getCardNo(),
              card.getCardName(), t.getTransAmt(),
              t.getMemberStoreType(), t.getMemberStoreName(), t.getTransactionDtm()))
          .toList();

      // 최종 반환할 리스트에 내역 추가
      transactions.addAll(cardTransactions);
    }

    Collections.sort(transactions);

    return TransactionResponse
        .builder()
        .rsp_code(200)
        .rsp_message("거래내역이 조회되었습니다.")
        .pay_cnt(transactions.size())
        .pay_list(transactions)
        .build();
  }
}
