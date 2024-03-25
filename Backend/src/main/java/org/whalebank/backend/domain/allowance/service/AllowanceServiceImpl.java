package org.whalebank.backend.domain.allowance.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.account.service.AccountService;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;
import org.whalebank.backend.domain.allowance.dto.request.AddGroupRequestDto;
import org.whalebank.backend.domain.allowance.dto.response.AddGroupResponseDto;
import org.whalebank.backend.domain.allowance.repository.GroupRepository;
import org.whalebank.backend.domain.allowance.repository.RoleRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class AllowanceServiceImpl implements AllowanceService{

  private final AuthRepository userRepository;
  private final GroupRepository groupRepository;
  private final AccountService accountService;
  private final RoleRepository roleRepository;

  @Override
  @Transactional
  public AddGroupResponseDto registerGroup(AddGroupRequestDto reqDto, String loginId) {
    UserEntity adult = getCurrentUser(loginId);
    UserEntity child = userRepository.findById(reqDto.getUser_id())
            .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 그룹, 역할 생성
    GroupEntity group = GroupEntity.from(reqDto);
    // 부모 -> 자녀 role 생성
    String groupNickname;
    if(reqDto.getGroup_nickname()==null) {
      groupNickname = child.getUserName();
    } else {
      groupNickname = reqDto.getGroup_nickname();
    }

    System.out.println(reqDto.is_monthly + ", 입력받은 계좌 고유번호: "+reqDto.getAccount_id()+", 계좌번호: "+reqDto.getAccount_num());
    RoleEntity adultRole = RoleEntity.of(adult, groupNickname, reqDto.getAccount_id(),
        reqDto.getAccount_num(), group);

    // 자녀 -> 부모 role 생성
    RoleEntity childRole = RoleEntity.of(child, adult.getUserName(), child.getAccountId(),
        child.getAccountNum(), group);

    roleRepository.save(adultRole);
    roleRepository.save(childRole);
    // 예약 이체 생성


    // 저장
    groupRepository.save(group);

    return AddGroupResponseDto.of(group, child.getAccountNum());
  }

  private UserEntity getCurrentUser(String loginId) {
    return userRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));


  }
}
