package org.whalebank.backend.domain.negotiation.service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.allowance.repository.GroupRepository;
import org.whalebank.backend.domain.allowance.repository.RoleRepository;
import org.whalebank.backend.domain.negotiation.NegotiationEntity;
import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoListResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoResponseDto;
import org.whalebank.backend.domain.negotiation.repository.NegotiationRepository;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class NegotiationServiceImpl implements NegotiationService{

  private final NegotiationRepository negotiationRepository;
  private final RoleRepository roleRepository;
  private final GroupRepository groupRepository;
  private final AuthRepository userRepository;

  @Override
  public NegoResponseDto requestNegotiation(NegoRequestDto reqDto, String loginId) {
    // 그룹 찾기
    GroupEntity group = groupRepository.findById(reqDto.getGroup_id())
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 그룹에 소속되어 있지 않으면 예외
    RoleEntity roleEntity = roleRepository.findByUserGroupAndUser(group, user)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND));

    // 네고 엔티티 생성 & 저장
    negotiationRepository.save(NegotiationEntity.of(group, reqDto, group.getAllowanceAmt()));

    // 부모 찾기
    List<RoleEntity> parent = roleRepository.findRoleEntitiesByUserGroupAndRole(group, Role.ADULT);

    return NegoResponseDto.of(reqDto.getNego_amt(), parent.get(0).getUser().getUserName());
  }

  @Override
  public List<NegoListResponseDto> findAllNegoList(int groupId, String loginId) {
    GroupEntity group = groupRepository.findById(groupId)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_NOT_FOUND));
    UserEntity user = userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    roleRepository.findByUserGroupAndUser(group, user)
        .orElseThrow(() -> new CustomException(ResponseCode.GROUP_ROLE_NOT_FOUND));

    return negotiationRepository.findAllByGroupOrderByCreateDtmDesc(group)
        .stream().map(NegoListResponseDto::from)
        .collect(Collectors.toList());
  }
}
