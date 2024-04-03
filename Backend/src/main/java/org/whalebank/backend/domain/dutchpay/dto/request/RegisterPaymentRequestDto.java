package org.whalebank.backend.domain.dutchpay.dto.request;

import java.util.List;
import lombok.Getter;

@Getter
public class RegisterPaymentRequestDto {

  public int room_id;  // 방 아이디

  public int account_id; // 계좌 고유번호

  public String account_num; // 계좌번호

  public String password;  // 계좌 비밀번호

  public List<Transaction> transactions;

  @Getter
  public static class Transaction {

    public int trans_id; // 거래 고유 번호
    public int trans_amt; // 거래 금액
    public String category;  // 카테고리
    public String member_store_name; // 거래 제목

  }
}
