package org.whalecard.whalecard.domain.card;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.whalecard.whalecard.domain.auth.AuthEntity;
import org.whalecard.whalecard.domain.transaction.TransactionEntity;

@Entity
@Table(name = "card")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class CardEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "card_id")
  private int cardId;

  private String cardNo;  // 카드번호

  private String cardName;  // 카드명

  private String accountNum;  // 결제 계좌번호

  private String cardPassword;  // 카드 비밀번호

  private LocalDate issueDate;  // 발급일자

  private LocalDate endDate;  // 만료일자

  @ManyToMany(mappedBy = "cardList")
  private List<AuthEntity> userList = new ArrayList<>();

  @OneToMany
  @JoinColumn(name = "card_id")
  private List<TransactionEntity> transactionList = new ArrayList<>();
}
