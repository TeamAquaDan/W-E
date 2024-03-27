package org.whalebank.backend.domain.notification.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.notification.NotificationEntity;

@Getter
@Setter
@Builder
public class NotiResponseDto {

  public int noti_id;
  public String name;
  public String content;
  public String category;
  public boolean is_read;

  public static NotiResponseDto from(NotificationEntity entity) {
    return NotiResponseDto.builder()
        .noti_id(entity.getNotiId())
        .name(entity.getNotiName())
        .content(entity.getNotiContent())
        .category(entity.getNotiContent())
        .is_read(entity.isRead())
        .build();
  }
}
