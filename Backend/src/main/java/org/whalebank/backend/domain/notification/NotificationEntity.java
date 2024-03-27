package org.whalebank.backend.domain.notification;

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
import org.hibernate.annotations.ColumnDefault;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.whalebank.backend.domain.notification.dto.request.FCMRequestDto;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EnableJpaAuditing
@Entity
@Table(name = "notification")
public class NotificationEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int notiId;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name="user_id")
  private UserEntity user;

  private String notiName;

  private String notiContent;

  private String notiCategory;

  @CreatedDate
  @Column(updatable = false)
  private LocalDateTime createdDtm;

  @ColumnDefault("0")
  private boolean isRead;

  public void setUser(UserEntity user) {
    this.user = user;
  }

  public void readNotification() {
    this.isRead = true;
  }

  public static NotificationEntity from(FCMRequestDto reqDto, UserEntity user) {
    return NotificationEntity.builder()
        .createdDtm(LocalDateTime.now())
        .notiName(reqDto.getTitle())
        .notiContent(reqDto.getContent())
        .notiContent(reqDto.getContent())
        .isRead(false)
        .user(user)
        .build();
  }

}
