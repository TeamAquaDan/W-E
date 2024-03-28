package org.whalebank.backend.domain.negotiation.service;

import org.whalebank.backend.domain.negotiation.dto.request.NegoRequestDto;
import org.whalebank.backend.domain.negotiation.dto.response.NegoResponseDto;

public interface NegotiationService {

  NegoResponseDto requestNegotiation(NegoRequestDto reqDto, String loginId);

}
