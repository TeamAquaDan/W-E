package org.whalebank.backend.global.openfeign.bank.request;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.global.openfeign.card.request.CardHistoryRequest;

@Getter
@Setter
@Builder
public class DepositListRequestDto {

  public LocalDateTime search_timestamp;

  public static DepositListRequestDto from(LocalDateTime lastCardHistoryFetchTime) {
    return DepositListRequestDto.builder()
        .search_timestamp(lastCardHistoryFetchTime)
        .build();
  }

}
