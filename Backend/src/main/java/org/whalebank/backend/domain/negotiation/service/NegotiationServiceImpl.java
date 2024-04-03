package org.whalebank.backend.domain.negotiation.service;

import jakarta.transaction.Transactional;
import java.text.NumberFormat;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.allowance.repository.GroupRepository;
import org.whalebank.backend.domain.allowance.repository.RoleRepository;
import org.whalebank.backend.domain.negotiation.NegotiationEntity;
import org.whalebank.backend.domain.negotiation.dto.request.NegoManageRequestDto;
import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoInfoResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoListResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoResponseDto;
import org.whalebank.backend.domain.negotiation.repository.NegotiationRepository;
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
public class NegotiationServiceImpl implements NegotiationService {

  private final NegotiationRepository negotiationRepository;
  private final GroupRepository groupRepository;
  private final RoleRepository roleRepository;
  private final FcmUtils fcmUtils;
  private final AuthRepository userRepository;
  static NumberFormat numberFormat = NumberFormat.getInstance();

  @Override
  public NegoResponseDto requestNegotiation(NegoRequestDto reqDto, String loginId) {
    // 그룹 찾기
    GroupEntity group = verifyUserGroup(reqDto.getGroup_id(), loginId);
    UserEntity child = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 네고 엔티티 생성 & 저장
    negotiationRepository.save(NegotiationEntity.of(group, reqDto, group.getAllowanceAmt()));

    // 부모에게 푸시 알림 전송
    UserEntity parent = findUserInGroupByRole(group, "ADULT");
    fcmUtils.sendNotificationByToken(parent, FCMRequestDto.of("용돈 인상 요청이 도착했어요!",
        child.getUserName() + "님께서 " + numberFormat.format(reqDto.getNego_amt()) + "원을 요청했어요!",
        FCMCategory.INCREASE_REQUEST));

    // 부모 이름 리턴
    return NegoResponseDto.of(reqDto.getNego_amt(), parent.getUserName());
  }

  @Override
  public List<NegoListResponseDto> findAllNegoList(int groupId, String loginId) {
    GroupEntity group = groupRepository.findById(groupId)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));

    UserEntity user = group.getMemberEntityList()
        .stream()
        .filter(r -> r.getRole().equals(Role.CHILD))
        .findFirst()
        .get()
        .getUser();

    RoleEntity roleEntity = roleRepository.findByUserGroupAndUser(group, user)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND));

    return negotiationRepository.findAllByGroupOrderByCreateDtmDesc(group)
        .stream()
        .map(n -> NegoListResponseDto.from(n, user.getUserName(), roleEntity.getGroupNickname()))
        .collect(Collectors.toList());
  }

  @Override
  public NegoInfoResponseDto findNegoByNegoId(int groupId, int negoId, String loginId) {
    GroupEntity group = verifyUserGroup(groupId, loginId);

    NegotiationEntity entity = negotiationRepository.findByNegoIdAndGroup(negoId, group)
        .orElseThrow(() -> new CustomException(ResponseCode.NEGO_NOT_FOUND));

    // 용돈 인상 요청자 이름 리턴
    return NegoInfoResponseDto.of(entity, findUserInGroupByRole(group, "CHILD").getUserName());
  }

  @Override
  @Transactional
  public void updateNegotiation(NegoManageRequestDto requestDto, String loginId) {
    UserEntity parent = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    NegotiationEntity entity = negotiationRepository.findById(requestDto.getNego_id())
        .orElseThrow(() -> new CustomException(ResponseCode.NEGO_NOT_FOUND));
    entity.manageNegotiation(requestDto.getComment(), requestDto.getResult());

    UserEntity child = entity.getGroup().getMemberEntityList().stream()
        .filter(r -> r.getRole().equals("CHILD"))
        .findFirst()
        .get()
        .getUser();

    if(requestDto.getResult()==1) {
      // 승인
      // 금액 변경
      entity.getGroup().updateAllowanceAmt(entity.getNegoAmt());
      entity.getGroup().getAutoPaymentEntity().updateAllowanceAmt(entity.getNegoAmt());
      // 푸시 알림 보내기
      System.out.println(numberFormat.format(entity.getNegoAmt())+"원");
      fcmUtils.sendNotificationByToken(child, FCMRequestDto.of("용돈 인상 요청이 승인되었어요!",
          child.getUserName() + "님의 용돈이 " + numberFormat.format(entity.getNegoAmt()) + "원으로 변경되었습니다.",
          FCMCategory.INCREASE_REQUEST_RESULT));
    } else {
      // 거절
      // 푸시 알림 보내기
      fcmUtils.sendNotificationByToken(child, FCMRequestDto.of("용돈 인상 요청이 거절되었어요!",
          child.getUserName() + "님의 용돈이 변경되지 않았습니다.",
          FCMCategory.INCREASE_REQUEST_RESULT));
    }
  }

  private GroupEntity verifyUserGroup(int groupId, String loginId) {
    GroupEntity group = groupRepository.findById(groupId)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));

    long count = group.getMemberEntityList()
        .stream()
        .filter(e -> Objects.equals(e.getUser().getLoginId(), loginId))
        .count();

    if (count == 0) {
      throw new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND);
    }
    return group;
  }

  private UserEntity findUserInGroupByRole(GroupEntity group, String role) {
    return group.getMemberEntityList()
        .stream()
        .filter(e -> e.getRole().equals(role))
        .findFirst()
        .get()
        .getUser();
  }

}
