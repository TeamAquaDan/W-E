package org.whalebank.backend.domain.dutchpay;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.whalebank.backend.domain.user.UserEntity;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "dutchpay")
public class DutchpayEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "dutchpay_id")
  private int dutchpayId;  // 더치페이 아이디

  @ColumnDefault("false")
  private boolean isCompleted; // 개인 정산금액 송금여부

  @ColumnDefault("false")
  private boolean isRegister; // 개인 정산금액 등록 여부

  private int accountId;    // 출금 계좌 고유번호

  private String accountNum;  // 출금 계좌번호

  private String accountPassword;  // 출금 계좌 비밀번호

  @ColumnDefault("0")
  private int totalAmt;   // 내 결제 총액

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "user_id")
  private UserEntity user;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "room_id")
  private DutchpayRoomEntity room;

  public static DutchpayEntity createRoom(UserEntity member, DutchpayRoomEntity dutchpayRoom) {
    return DutchpayEntity
        .builder()
        .user(member)
        .room(dutchpayRoom)
        .build();
  }
}
