package org.whalebank.backend.domain.mission.service;

import java.util.List;
import org.whalebank.backend.domain.mission.dto.request.MissionCreateRequestDto;
import org.whalebank.backend.domain.mission.dto.response.MissionInfoResponseDto;

public interface MissionService {

  MissionInfoResponseDto createMission(MissionCreateRequestDto reqDto, String loginId);

  List<MissionInfoResponseDto> getAllMission(int groupId, String loginId);

}
