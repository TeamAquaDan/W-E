package org.whalebank.backend.domain.dutchpay.service;

import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayRoomResponseDto;

public interface DutchpayService {

  DutchpayRoomResponseDto createDutchpayRoom(String loginId, DutchpayRoomRequestDto request);
}
