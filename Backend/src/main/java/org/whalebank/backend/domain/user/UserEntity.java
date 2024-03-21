package org.whalebank.backend.domain.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.goal.GoalEntity;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users")
public class UserEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int userId;

  private String userName;

  private LocalDate birthDate;

  // 카드사 접근 토큰
  private String cardAccessToken;

  // 은행 접근 토큰
  private String bankAccessToken;

  // fcm 토큰
  private String fcmToken;

  // 부모/자녀
  @Enumerated(EnumType.STRING)
  private Role role;

  @CreatedDate
  @Column(updatable = false)
  private LocalDateTime createdDtm;

  private LocalDateTime deletedDtm;

  private boolean isDeleted;

  private String profileImage;

  private int accountId;

  private String phoneNum;

  private String userCi;

  private String loginId;

  private String loginPassword;


  private LocalDateTime lastCardHistoryFetchTime;

  @OneToMany
  @JoinColumn(name = "goal_id")
  private List<GoalEntity> goalList = new ArrayList<>();

  public void updateBankAccessToken(String token) {
    this.bankAccessToken = token;
  }

  public void updateCardAccessToken(String token) {
    this.cardAccessToken = token;
  }

  public void updateMainAccount(int accountId) {
    this.accountId = accountId;
  }

  public void updateFcmToken(String fcmToken) {
    this.fcmToken = fcmToken;
  }

  public void updateCardFetchTime() {
    this.lastCardHistoryFetchTime = LocalDateTime.now();
  }

  public void addGoal(GoalEntity goal) {
    this.goalList.add(goal);
  }

}
