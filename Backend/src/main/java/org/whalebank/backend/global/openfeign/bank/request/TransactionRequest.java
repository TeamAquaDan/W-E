package org.whalebank.backend.global.openfeign.bank.request;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.account.dto.request.TransactionHistoryRequestDto;

@Getter
@Setter
@Builder
public class TransactionRequest {

  public int account_id;
  public LocalDate from_date;
  public LocalDate to_date;

  public static TransactionRequest from(TransactionHistoryRequestDto reqDto) {
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    return TransactionRequest.builder()
        .account_id(reqDto.getAccount_id())
        .from_date(LocalDate.parse(reqDto.getStart_date(), format))
        .to_date(LocalDate.parse(reqDto.getEnd_date(), format))
        .build();
  }

  public static TransactionRequest of(int accountId, LocalDateTime startDate) {
    return TransactionRequest.builder()
        .account_id(accountId)
        .from_date(LocalDate.from(startDate))
        .to_date(LocalDate.now())
        .build();
  }

}
