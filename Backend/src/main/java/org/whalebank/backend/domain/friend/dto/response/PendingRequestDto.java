package org.whalebank.backend.domain.friend.dto.response;

import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.friend.FriendshipEntity;

@Setter
@Getter
@Builder
public class PendingRequestDto {

  public int friend_id;
  public String friend_name;
  public String friend_loginId;
  public String created_at;

  public static PendingRequestDto of(FriendshipEntity entity) {

    return PendingRequestDto.builder()
        .friend_id(entity.getFromUser().getUserId())
        .friend_name(entity.getFromUser().getUserName())
        .friend_loginId(entity.getFromUser().getLoginId())
        .created_at(entity.getCreatedDtm().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))) // 친구 요청 일자 yyyy-mm-dd
        .build();
  }

}
