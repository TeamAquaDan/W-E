package org.whalebank.whalebank.domain.transfer;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.account.dto.request.ParkingRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.DepositRequest;
import org.whalebank.whalebank.domain.transfer.dto.request.WithdrawRequest;

@Entity
@Table(name = "transfer")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class TransferEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "trans_id")
  private int transId;

  private int transType;  // 거래유형 출금(2), 입금(3)

  private int transAmt; // 거래 금액

  private int balanceAmt; // 거래 후 잔액

  private String transMemo; // 적요

  private LocalDateTime transDtm; // 거래일시

  private LocalDate transDate; // 거래일자

  private String recvClientName; // 수취고객성명

  private String recvClientAccountNum; // 최종 수취고객 계좌번호

  private String recvClientBankCode; // 최종수취고객계좌 개설기관 표준코드


  public static TransferEntity createTransfer(WithdrawRequest withdrawRequest, int balanceAmt) {
    return TransferEntity
        .builder()
        .transType(2)
        .transAmt(withdrawRequest.getTran_amt())
        .balanceAmt(balanceAmt)
        .transMemo(withdrawRequest.getReq_trans_memo())
        .transDtm(LocalDateTime.now())
        .transDate(LocalDate.now())
        .recvClientName(withdrawRequest.getRecv_client_name())
        .recvClientAccountNum(withdrawRequest.getRecv_client_account_num())
        .recvClientBankCode(withdrawRequest.getRecv_client_bank_code())
        .build();
  }

  public static TransferEntity createTransfer(DepositRequest depositRequest, int balanceAmt) {
    return TransferEntity
        .builder()
        .transType(3)
        .transAmt(depositRequest.getTrans_amt())
        .balanceAmt(balanceAmt)
        .transMemo(depositRequest.getRecv_trans_memo())
        .transDtm(LocalDateTime.now())
        .transDate(LocalDate.now())
        .recvClientName(depositRequest.getRecv_client_name())
        .recvClientAccountNum(depositRequest.getRecv_client_account_num())
        .recvClientBankCode(depositRequest.getRecv_client_bank_code())
        .build();
  }

  public static TransferEntity createTransfer(ParkingRequest parkingRequest,
      AccountEntity account) {
    return TransferEntity
        .builder()
        .transType(2)
        .transAmt(parkingRequest.getParking_amt())
        .balanceAmt(account.getBalanceAmt())
        .transMemo("저금하기")
        .transDtm(LocalDateTime.now())
        .transDate(LocalDate.now())
        .recvClientName("저금통")
        .recvClientAccountNum(account.getAccountNum())
        .recvClientBankCode(account.getBankCode())
        .build();
  }

  public static TransferEntity createTransfer(int parkingBalanceAmt, AccountEntity account) {
    return TransferEntity
        .builder()
        .transType(3)
        .transAmt(parkingBalanceAmt)
        .balanceAmt(account.getBalanceAmt())
        .transMemo("저금하기 종료")
        .transDtm(LocalDateTime.now())
        .transDate(LocalDate.now())
        .recvClientName("저금통")
        .recvClientAccountNum(account.getAccountNum())
        .recvClientBankCode(account.getBankCode())
        .build();
  }
}
