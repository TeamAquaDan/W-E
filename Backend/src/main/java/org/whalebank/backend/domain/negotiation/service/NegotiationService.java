package org.whalebank.backend.domain.negotiation.service;

import java.util.List;
import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoInfoResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoListResponseDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoResponseDto;

public interface NegotiationService {

  NegoResponseDto requestNegotiation(NegoRequestDto reqDto, String loginId);

  List<NegoListResponseDto> findAllNegoList(int groupId, String loginId);

  NegoInfoResponseDto findNegoByNegoId(int groupId, int negoId, String loginId);
}
