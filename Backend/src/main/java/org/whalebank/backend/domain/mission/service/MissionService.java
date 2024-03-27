package org.whalebank.backend.domain.mission.service;

import org.whalebank.backend.domain.mission.dto.request.MissionCreateRequestDto;
import org.whalebank.backend.domain.mission.dto.response.MissionInfoResponseDto;

public interface MissionService {

  MissionInfoResponseDto createMission(MissionCreateRequestDto reqDto, String loginId);

}
