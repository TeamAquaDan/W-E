package org.whalebank.whalebank.domain.account;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse.Account;
import org.whalebank.whalebank.domain.auth.AuthEntity;

@Entity
@Table(name = "account")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class AccountEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "account_id")
  private int accountId;

  private String accountNum;  // 계좌번호

  private String accountName; // 계좌명

  private int balanceAmt; // 현재잔액

  @ColumnDefault("5000000")
  private int dayLimitAmt;  // 1일 한도 (5,000,000)

  @ColumnDefault("1000000")
  private int onceLimitAmt; // 1회 한도 (1,000,000)

  @ColumnDefault("1000000")
  private int withdrawableAmt;  // 출금가능액 ( = 1일 한도)

  private String accountPassword; // 비밀번호

  private int AccountType; // 모임통장(0), 개인통장(1)

  @ColumnDefault("0")
  private int parkingBalanceAmt; // 파킹통장 잔액

  private LocalDateTime issueDate; // yyyyMMdd

  private LocalDateTime closingDate;  // 계좌해지일자

  @ManyToMany(mappedBy = "accountList")
  private List<AuthEntity> userList = new ArrayList<>();

  public void depositParking(int depositAmt) {

    this.balanceAmt -= depositAmt;
    this.parkingBalanceAmt += depositAmt;

  }

  public void withdrawParking() {

    this.balanceAmt += this.parkingBalanceAmt;
    this.parkingBalanceAmt = 0;

  }
}
