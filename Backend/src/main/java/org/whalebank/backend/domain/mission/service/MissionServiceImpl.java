package org.whalebank.backend.domain.mission.service;

import jakarta.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.allowance.repository.GroupRepository;
import org.whalebank.backend.domain.allowance.repository.RoleRepository;
import org.whalebank.backend.domain.mission.MissionEntity;
import org.whalebank.backend.domain.mission.dto.request.MissionCreateRequestDto;
import org.whalebank.backend.domain.mission.dto.request.MissionManageRequestDto;
import org.whalebank.backend.domain.mission.dto.response.MissionInfoResponseDto;
import org.whalebank.backend.domain.mission.repository.MissionRepository;
import org.whalebank.backend.domain.notification.FCMCategory;
import org.whalebank.backend.domain.notification.dto.request.FCMRequestDto;
import org.whalebank.backend.domain.notification.service.FcmUtils;
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
  private final FcmUtils fcmUtils;

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

  @Override
  public List<MissionInfoResponseDto> getAllMission(int groupId, String loginId) {
    UserEntity currentUser = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    GroupEntity group = groupRepository.findById(groupId)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));

    // 현재 유저가 group에 소속되어 있지 않다면 예외
    roleRepository.findByUserGroupAndUser(group, currentUser)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND));

    // 미션 제공자 찾기
    String providerName;
    List<RoleEntity> roleEntityList = group.getMemberEntityList();
    providerName = roleEntityList.stream()
        .filter(roleEntity -> roleEntity.getRole().equals("ADULT")).findFirst()
        .map(roleEntity -> roleEntity.getUser().getUserName()).orElse(null);

    // 미션 목록
    return missionRepository.findAllByGroup(group)
        .stream().map(m -> MissionInfoResponseDto.from(m, providerName))
        .collect(Collectors.toList());
  }

  @Override
  @Transactional
  public MissionInfoResponseDto manageMission(MissionManageRequestDto reqDto, String loginId) {
    UserEntity currentUser = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    GroupEntity group = groupRepository.findById(reqDto.getGroup_id())
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));

    // 현재 유저가 group에 소속되어 있지 않다면 예외
    RoleEntity roleEntity = roleRepository.findByUserGroupAndUser(group, currentUser)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND));

    MissionEntity mission = missionRepository.findById(reqDto.getMission_id())
        .orElseThrow(() -> new CustomException(ResponseCode.MISSION_NOT_FOUND));

    // 미션 성공/실패
    mission.manageMission(reqDto.getStatus());
    // 자녀에게 푸시 알림 보내기
    UserEntity child = findMemberInGroup(group, "CHILD");
    if(reqDto.getStatus()==1) { // 성공
      fcmUtils.sendNotificationByToken(child, FCMRequestDto.of("미션 성공!", String.format("'%s' 미션을 성공했어요!", mission.getMissionName()),
          FCMCategory.MISSION_RESULT));
    } else { // 실패
      fcmUtils.sendNotificationByToken(child, FCMRequestDto.of("미션 실패!", String.format("'%s' 미션을 실패했어요!", mission.getMissionName()),
          FCMCategory.MISSION_RESULT));
    }

    // 미션 제공자 찾기
    String providerName = null;
    List<RoleEntity> roleEntityList = group.getMemberEntityList();
    for(RoleEntity role: roleEntityList) {
      if (role.getRole().equals("ADULT")) {
        providerName = role.getUser().getUserName();
        break;
      }
    }

    return MissionInfoResponseDto.from(mission, providerName);
  }

  private UserEntity findMemberInGroup(GroupEntity group, String role) {
    for(RoleEntity roleEntity : group.getMemberEntityList()) {
      if (roleEntity.getRole().equals(role)) {
        return roleEntity.getUser();
      }
    }
    return null;
  }
}
