package org.whalebank.backend.domain.mission.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MissionCreateRequestDto {

  public int group_id;
  public String mission_name;
  public int mission_reward;
  public String deadline_date;

}
