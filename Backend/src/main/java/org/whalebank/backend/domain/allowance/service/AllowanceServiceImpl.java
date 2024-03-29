package org.whalebank.backend.domain.allowance.service;

import jakarta.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.allowance.AutoPaymentEntity;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.allowance.dto.request.AddGroupRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateAllowanceRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateNicknameRequestDto;
import org.whalebank.backend.domain.allowance.dto.response.AllowanceInfoResponseDto;
import org.whalebank.backend.domain.allowance.dto.response.ChildrenDetailResponseDto;
import org.whalebank.backend.domain.allowance.dto.response.ChildrenInfoResponseDto;
import org.whalebank.backend.domain.allowance.dto.response.GroupInfoResponseDto;
import org.whalebank.backend.domain.allowance.repository.GroupRepository;
import org.whalebank.backend.domain.allowance.repository.RoleRepository;
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
public class AllowanceServiceImpl implements AllowanceService{

  private final AuthRepository userRepository;
  private final GroupRepository groupRepository;
  private final RoleRepository roleRepository;
  private final FcmUtils fcmUtils;

  @Override
  @Transactional
  public GroupInfoResponseDto registerGroup(AddGroupRequestDto reqDto, String loginId) {
    UserEntity adult = getCurrentUser(loginId);
    UserEntity child = userRepository.findById(reqDto.getUser_id())
            .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 부모 - 자녀 쌍이 이미 존재한다면 예외
    List<RoleEntity> roleEntityList = roleRepository.findRolesByUserId(child.getUserId(),
        Role.ADULT);
    if (roleEntityList.stream().anyMatch(r -> r.getUser().getUserId() == adult.getUserId())) {
      throw new CustomException(ResponseCode.ALREADY_ADDED_CHILD);
    }


    // 그룹, 역할 생성
    GroupEntity group = GroupEntity.from(reqDto);
    // 부모 -> 자녀 role 생성
    String groupNickname;
    if(reqDto.getGroup_nickname()==null) {
      groupNickname = child.getUserName();
    } else {
      groupNickname = reqDto.getGroup_nickname();
    }

    RoleEntity adultRole = RoleEntity.of(adult, adult.getUserName(), reqDto.getAccount_id(),
        reqDto.getAccount_num(), group);

    // 자녀 -> 부모 role 생성
    RoleEntity childRole = RoleEntity.of(child, groupNickname, child.getAccountId(),
        child.getAccountNum(), group);

    group.addRole(adultRole);
    group.addRole(childRole);

    AutoPaymentEntity autoPaymentEntity = group.setAutoPaymentEntity(
        AutoPaymentEntity.of(childRole, adultRole,
            reqDto.getAccount_password(), reqDto.getAllowance_amt()
        ));
    autoPaymentEntity.calculateNextAutoPaymentDate(reqDto.getIs_monthly(),
        reqDto.getPayment_date());

    // 저장
    groupRepository.save(group);
    // 자녀에게 푸시 알림 전송
    fcmUtils.sendNotificationByToken(child,
        FCMRequestDto.of(adult.getUserName() + "님께서 " + child.getUserName() + "님을 추가했어요",
            "이제부터 " + adult.getUserName() + "님께 용돈을 받을 수 있어요!",
            FCMCategory.PARENT_ADD_CHILD)
    );

    return GroupInfoResponseDto.of(group, child.getAccountNum());
  }

  @Override
  @Transactional
  public GroupInfoResponseDto updateGroup(UpdateAllowanceRequestDto reqDto, String loginId) {
    UserEntity loginUser = getCurrentUser(loginId);

    // 존재하지 않는 그룹일 경우 예외
    GroupEntity group = groupRepository.findById(reqDto.getGroup_id())
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));

    // 본인이 소속된 그룹이 아니라면 예외
    boolean hasAuthority = false;
    for(RoleEntity entity: roleRepository.findRoleEntitiesByUserGroupAndRole(group, Role.ADULT)) {
      if(entity.getUser().getUserId() == loginUser.getUserId()) {
        hasAuthority = true;
        break;
      }
    }
    if(!hasAuthority) {
      throw new CustomException(ResponseCode.GROUP_EDIT_FORBIDDEN);
    }
    // CHILD 찾기
    RoleEntity child = roleRepository.findRoleEntitiesByUserGroupAndRole(group, Role.CHILD).get(0);

    group.updateGroup(reqDto);
    return GroupInfoResponseDto.of(group,child.getUser().getAccountNum());
  }

  @Override
  @Transactional
  public void updateNickname(UpdateNicknameRequestDto reqDto, String loginId) {
    UserEntity loginUser = getCurrentUser(loginId);

    // 존재하지 않는 그룹일 경우 예외
    GroupEntity group = groupRepository.findById(reqDto.getGroup_id())
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));

    // 그룹 아이디, 유저 아이디로 role 찾기
    List<RoleEntity> roleEntities = roleRepository.findByUserGroupAndRole(group,
        loginUser.getRole() == Role.ADULT ? Role.CHILD : Role.ADULT);
    for(RoleEntity entity : roleEntities) {
      entity.updateNickname(reqDto.getGroup_nickname());
    }

  }

  // 자녀가 용돈 목록 조회
  @Override
  public List<AllowanceInfoResponseDto> getAllowanceList(String loginId) {
    UserEntity child = getCurrentUser(loginId);
    List<AllowanceInfoResponseDto> result = new ArrayList<>();

    // role 중에서 ADULT만 찾기, role과 연결된 group 찾기
    List<RoleEntity> roleEntityList = roleRepository.findRolesByUserId(child.getUserId(),
        Role.ADULT);
    for(RoleEntity entity:roleEntityList) {
      result.add(AllowanceInfoResponseDto.from(entity));
    }

    return result;
  }

  @Override
  public List<ChildrenInfoResponseDto> getChildrenList(String loginId) {
    UserEntity adult = getCurrentUser(loginId);
    List<ChildrenInfoResponseDto> result = new ArrayList<>();

    List<RoleEntity> roleEntityList = roleRepository.findRolesByUserId(adult.getUserId(),
        Role.CHILD);
    for(RoleEntity entity:roleEntityList) {
      result.add(ChildrenInfoResponseDto.from(entity));
    }
    return result;

  }

  @Override
  public ChildrenDetailResponseDto getChildDetail(String loginId, int groupId, int childId) {
    // 부모
    UserEntity parent = getCurrentUser(loginId);
    // 자녀가 포함된 그룹
    GroupEntity group = groupRepository.findById(groupId)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));
    // 상세 조회할 자녀
    UserEntity child = userRepository.findById(childId)
            .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 부모가 자녀와 같은 그룹에 포함되어 있지 않으면 예외
    roleRepository.findByUserGroupAndUser(group, parent)
            .orElseThrow(() ->  new CustomException(ResponseCode.USER_VIEW_FORBIDDEN));
    // 자녀가 그룹에 포함되어 있지 않으면 예외
    RoleEntity childRole = roleRepository.findByUserGroupAndUser(group, child)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND));

    return ChildrenDetailResponseDto.of(childRole.getUserGroup(), child);

  }

  private UserEntity getCurrentUser(String loginId) {
    return userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));
  }

}
