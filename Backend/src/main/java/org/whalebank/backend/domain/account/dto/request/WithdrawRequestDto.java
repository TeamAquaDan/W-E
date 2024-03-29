package org.whalebank.backend.domain.account.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.allowance.AutoPaymentEntity;
import org.whalebank.backend.domain.mission.MissionEntity;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WithdrawRequestDto {

  public int tran_amt; // 거래 금액
  public int req_account_id; // 계좌 고유 번호
  public String req_account_num; // 요청 고객 계좌번호
  public String req_account_password; // 요청 고객 계좌 비밀번호
  public String recv_client_bank_code; // 최종수취고객 계좌 개설기관 표준코드
  public String recv_client_account_num; // 최종수최고객 계좌번호
  public String recv_client_name;
  public String req_trans_memo; // 내 거래내역에 표기할 메모
  public String recv_trans_memo; // 상대방 거래내역에 표기할 메모


  public static WithdrawRequestDto create(int tranAmt, DutchpayEntity request,
      DutchpayEntity response) {
    return WithdrawRequestDto
        .builder()
        .tran_amt(tranAmt)
        .req_account_id(request.getAccountId())
        .req_account_num(request.getAccountNum())
        .req_account_password(request.getAccountPassword())
        .recv_client_bank_code("103")
        .recv_client_account_num(response.getAccountNum())
        .recv_client_name(response.getUser().getUserName())
        .req_trans_memo(response.getUser().getUserName())
        .recv_trans_memo(request.getUser().getUserName())
        .build();
  }

  public static WithdrawRequestDto of(AutoPaymentEntity entity, String parentName) {
    return WithdrawRequestDto.builder()
        .tran_amt(entity.getReservedAmt())
        .req_account_id(entity.getParentAccountId())
        .req_account_num(entity.getParentAccountNum())
        .req_account_password(entity.getParentAccountPassword())
        .recv_client_bank_code("103")
        .recv_client_account_num(entity.getRecvAccountNum())
        .recv_client_name(entity.getChildName())
        .req_trans_memo(entity.getChildName() + " 용돈")
        .recv_trans_memo(parentName + "님께 받은 용돈")
        .build();
  }

  public static WithdrawRequestDto of(AutoPaymentEntity entity, MissionEntity mission, String parentName) {
    return WithdrawRequestDto.builder()
        .tran_amt(mission.getMissionReward())
        .req_account_id(entity.getParentAccountId())
        .req_account_num(entity.getParentAccountNum())
        .req_account_password(entity.getParentAccountPassword())
        .recv_client_bank_code("103")
        .recv_client_account_num(entity.getRecvAccountNum())
        .recv_client_name(entity.getChildName())
        .req_trans_memo(entity.getChildName()+"님 " + mission.getMissionName()+ " 미션 성공 보상금액")
        .recv_trans_memo(mission.getMissionName() + " 미션 성공 보상 금액")
        .build();
  }


}