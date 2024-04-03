package org.whalebank.backend.domain.account.dto.response;

import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.global.openfeign.bank.response.TransactionResponse.Transaction;

@Getter
@Setter
@Builder
public class TransactionHistoryResponseDto {

   public int trans_type; // 거래유형, (출금(2), 입금(3))
   public int trans_amt; // 거래금액
   public int balance_amt; // 거래 후 잔액
   public String trans_memo;  // 적요
   public String trans_dtm; // 거래일시 yyyy.mm.dd HH:mm

   public static TransactionHistoryResponseDto from(Transaction transaction) {
      return TransactionHistoryResponseDto.builder()
          .trans_type(transaction.getTrans_type())
          .trans_amt(transaction.getTrans_amt())
          .balance_amt(transaction.getBalance_amt())
          .trans_memo(transaction.getTrans_memo())
          .trans_dtm(transaction.getTrans_dtm().format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm")))
          .build();
   }

}
