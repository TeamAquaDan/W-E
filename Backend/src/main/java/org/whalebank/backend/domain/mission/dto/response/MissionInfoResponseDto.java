package org.whalebank.backend.domain.mission.dto.response;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.mission.MissionEntity;

@Getter
@Setter
@Builder
public class MissionInfoResponseDto {

  public int mission_id;
  public String mission_name;
  public int mission_reward;
  public String deadline_date; // yyyy-mm-dd
  public int status; // 상태 0(진행중), 1(성공), 2(실패)
  public String user_name; // 미션 제공자 이름

  public static MissionInfoResponseDto from(MissionEntity entity, String providerName) {
    return MissionInfoResponseDto.builder()
        .mission_id(entity.getMission_id())
        .mission_name(entity.getMissionName())
        .mission_reward(entity.getMissionReward())
        .deadline_date(entity.getDeadlineDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")))
        .status(entity.getStatus())
        .user_name(providerName)
        .build();
  }

}
