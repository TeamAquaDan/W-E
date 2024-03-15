package org.whalebank.backend.domain.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

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

  // 은행 접근 토큰

  // fcm 토큰

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

}
