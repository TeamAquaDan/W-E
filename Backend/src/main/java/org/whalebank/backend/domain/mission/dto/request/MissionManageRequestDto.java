package org.whalebank.backend.domain.mission.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MissionManageRequestDto {

  public int group_id;
  public int mission_id;
  public int status;

}
