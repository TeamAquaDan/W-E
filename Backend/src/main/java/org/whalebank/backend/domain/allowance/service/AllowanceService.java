package org.whalebank.backend.domain.allowance.service;

import org.whalebank.backend.domain.allowance.dto.request.AddGroupRequestDto;
import org.whalebank.backend.domain.allowance.dto.response.AddGroupResponseDto;

public interface AllowanceService {

  public AddGroupResponseDto registerGroup(AddGroupRequestDto reqDto, String loginId);

}
