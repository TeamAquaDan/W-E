package org.whalebank.backend.domain.friend;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedDate;
import org.whalebank.backend.domain.user.UserEntity;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name="friendship")
public class FriendshipEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int friendshipId;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "to_user_id")
  private UserEntity toUser; // 친구 요청 수신자

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "from_user_id")
  private UserEntity fromUser; // 친구 요청 요청자

  @CreatedDate
  @Column(updatable = false)
  private LocalDateTime createdDtm;

  @ColumnDefault("0")
  private int status; // 요청 상태 0(대기중), 1(승인), 2(거절)

  @UpdateTimestamp
  private LocalDateTime completedDtm; // 처리 일시

  public static FriendshipEntity of(UserEntity requester, UserEntity receiver) {
    return FriendshipEntity.builder()
        .fromUser(requester)
        .toUser(receiver)
        .build();
  }

  public void updateStatus(int status) {
    this.status = status; // 1:승인, 2:거절
  }
}
