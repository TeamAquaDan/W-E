package org.whalebank.backend.domain.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.Fetch;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.friend.FriendEntity;
import org.whalebank.backend.domain.goal.GoalEntity;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users")
public class UserEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "user_id")
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

  private String accountNum;

  private String phoneNum;

  private String userCi;

  private String loginId;

  private String loginPassword;

  private LocalDateTime lastCardHistoryFetchTime;

  @OneToMany(mappedBy = "user")
  private List<GoalEntity> goalList = new ArrayList<>();

  @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
  private ProfileEntity profile;

  @OneToMany(mappedBy = "user")
  private List<RoleEntity> roleEntityList = new ArrayList<>();

  public void updateSentence(String sentence) {
    this.profile.setSentence(sentence);
  }

  public void updateBankAccessToken(String token) {
    this.bankAccessToken = token;
  }

  public void updateCardAccessToken(String token) {
    this.cardAccessToken = token;
  }

  public void updateMainAccount(int accountId, String accountNum) {
    this.accountId = accountId;
    this.accountNum = accountNum;
  }

  public void updateFcmToken(String fcmToken) {
    this.fcmToken = fcmToken;
  }

  public void updateCardFetchTime() {
    this.lastCardHistoryFetchTime = LocalDateTime.now();
  }

  public void addGoal(GoalEntity goal) {
    goal.setUser(this);
    this.goalList.add(goal);
  }

}
