package org.whalebank.backend.global.openfeign.card.request;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class CardHistoryRequest {

  public LocalDateTime search_timestamp;

  public static CardHistoryRequest from(LocalDateTime lastCardHistoryFetchTime) {
    return CardHistoryRequest.builder()
        .search_timestamp(lastCardHistoryFetchTime)
        .build();
  }

}
