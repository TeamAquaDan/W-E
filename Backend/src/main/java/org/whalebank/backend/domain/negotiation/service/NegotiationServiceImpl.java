package org.whalebank.backend.domain.negotiation.service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.repository.GroupRepository;
import org.whalebank.backend.domain.negotiation.NegotiationEntity;
import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoInfoResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoListResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoResponseDto;
import org.whalebank.backend.domain.negotiation.repository.NegotiationRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class NegotiationServiceImpl implements NegotiationService {

  private final NegotiationRepository negotiationRepository;
  private final GroupRepository groupRepository;

  @Override
  public NegoResponseDto requestNegotiation(NegoRequestDto reqDto, String loginId) {
    // 그룹 찾기
    GroupEntity group = verifyUserGroup(reqDto.getGroup_id(), loginId);

    // 네고 엔티티 생성 & 저장
    negotiationRepository.save(NegotiationEntity.of(group, reqDto, group.getAllowanceAmt()));

    // 부모 이름 리턴
    return NegoResponseDto.of(reqDto.getNego_amt(), findUserNameInGroupByRole(group, "ADULT"));
  }

  @Override
  public List<NegoListResponseDto> findAllNegoList(int groupId, String loginId) {
    GroupEntity group = verifyUserGroup(groupId, loginId);

    return negotiationRepository.findAllByGroupOrderByCreateDtmDesc(group)
        .stream().map(NegoListResponseDto::from)
        .collect(Collectors.toList());
  }

  @Override
  public NegoInfoResponseDto findNegoByNegoId(int groupId, int negoId, String loginId) {
    GroupEntity group = verifyUserGroup(groupId, loginId);

    NegotiationEntity entity = negotiationRepository.findByNegoIdAndGroup(negoId, group)
        .orElseThrow(() -> new CustomException(ResponseCode.NEGO_NOT_FOUND));

    // 용돈 인상 요청자 이름 리턴
    return NegoInfoResponseDto.of(entity, findUserNameInGroupByRole(group, "CHILD"));
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

  private String findUserNameInGroupByRole(GroupEntity group, String role) {
    return group.getMemberEntityList()
        .stream()
        .filter(e -> e.getRole().equals(role))
        .findFirst()
        .get()
        .getUser()
        .getUserName();
  }

}
