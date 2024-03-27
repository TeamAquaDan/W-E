package org.whalebank.backend.domain.dutchpay.dto.request;

import java.util.List;
import lombok.Getter;

@Getter
public class PaymentRequestDto {

  private int room_id;  // 방 아이디 

  private int account_id; // 계좌 고유번호

  private String account_num; // 계좌번호

  private String password;  // 계좌 비밀번호

  private List<Integer> trans_ids; // 거래 고유 번호
}
