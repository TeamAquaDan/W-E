package org.whalebank.backend.domain.dutchpay;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.user.UserEntity;

@Entity
@Getter
@Setter
@Builder
@Table(name = "dutchpay_room")
@NoArgsConstructor
@AllArgsConstructor
public class DutchpayRoomEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "room_id")
  private int roomId;  // 방 아이디

  @ColumnDefault("false")
  private boolean isCompleted; // 정산 완료 여부

  private String roomName; // 방 제목

  private LocalDate dutchpayDate; // 결제 일자

  private int managerId; // 방장 아이디

  @ColumnDefault("0")
  private int setAmtCount;  // 정산 금액 등록 인원수

  public static DutchpayRoomEntity createRoom(DutchpayRoomRequestDto request, UserEntity user) {
    return DutchpayRoomEntity
        .builder()
        .roomName(request.getRoom_name())
        .dutchpayDate(LocalDate.parse(request.getDutchpay_date()))
        .managerId(user.getUserId())
        .build();
  }
}
