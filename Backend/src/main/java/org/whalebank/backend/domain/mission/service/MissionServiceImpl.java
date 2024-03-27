package org.whalebank.backend.domain.mission.service;

import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.allowance.repository.GroupRepository;
import org.whalebank.backend.domain.allowance.repository.RoleRepository;
import org.whalebank.backend.domain.mission.MissionEntity;
import org.whalebank.backend.domain.mission.dto.request.MissionCreateRequestDto;
import org.whalebank.backend.domain.mission.dto.response.MissionInfoResponseDto;
import org.whalebank.backend.domain.mission.repository.MissionRepository;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

  private final MissionRepository missionRepository;
  private final GroupRepository groupRepository;
  private final RoleRepository roleRepository;
  private final AuthRepository userRepository;

  @Override
  public MissionInfoResponseDto createMission(MissionCreateRequestDto reqDto, String loginId) {
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    GroupEntity group = groupRepository.findById(reqDto.getGroup_id())
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));


    // 현재 유저가 group에 소속되어 있지 않다면 예외
    roleRepository.findByUserGroupAndUser(group, user)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND));

    // 미션 엔티티 생성
    MissionEntity entity = MissionEntity.of(reqDto, group);
    missionRepository.save(entity);
    // 미션 제공자 찾기
    String providerName = null;
    List<RoleEntity> roleEntityList = group.getMemberEntityList();
    for(RoleEntity roleEntity: roleEntityList) {
      if (roleEntity.getRole().equals("ADULT")) {
        providerName = roleEntity.getUser().getUserName();
        break;
      }
    }

    return MissionInfoResponseDto.from(entity, providerName);
  }
}
