package org.whalebank.backend.domain.allowance.service;

import java.util.List;
import org.whalebank.backend.domain.allowance.dto.request.AddGroupRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateAllowanceRequestDto;
import org.whalebank.backend.domain.allowance.dto.request.UpdateNicknameRequestDto;
import org.whalebank.backend.domain.allowance.dto.response.AllowanceInfoResponseDto;
import org.whalebank.backend.domain.allowance.dto.response.GroupInfoResponseDto;

public interface AllowanceService {

  public GroupInfoResponseDto registerGroup(AddGroupRequestDto reqDto, String loginId);

  public GroupInfoResponseDto updateGroup(UpdateAllowanceRequestDto reqDto, String loginId);

  public void updateNickname(UpdateNicknameRequestDto reqDto, String loginId);

  public List<AllowanceInfoResponseDto> getAllowanceList(String loginId);


}
