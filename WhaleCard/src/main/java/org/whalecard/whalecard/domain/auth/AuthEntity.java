package org.whalecard.whalecard.domain.auth;

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
import org.whalecard.whalecard.domain.card.CardEntity;

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
      inverseJoinColumns = @JoinColumn(name = "card_id")
  )
  @Builder.Default
  private List<CardEntity> cardList = new ArrayList<>();

  public void addCard(CardEntity card) {
    cardList.add(card);
  }
}
