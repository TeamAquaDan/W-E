package org.whalebank.whalebank.domain.auth;

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
import lombok.*;
import org.antlr.v4.runtime.misc.NotNull;
import org.whalebank.whalebank.domain.account.AccountEntity;
import org.whalebank.whalebank.domain.account.dto.response.AccountResponse.Account;

@Entity
@Table(name = "user")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class AuthEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "user_id")
  private int userId;

  private String userName;

  private String phoneNum;

  private String birthDate;

  private LocalDateTime createdDtm;

  private String userCi;

  private String refreshToken;

  @ManyToMany
  @JoinTable(
      name = "owner",
      joinColumns = @JoinColumn(name = "user_id"),
      inverseJoinColumns = @JoinColumn(name = "account_id")
  )
  @Builder.Default
  private List<AccountEntity> accountList = new ArrayList<>();

  public void addAccount(AccountEntity account) {
    accountList.add(account);
  }

}
