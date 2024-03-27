package org.whalebank.backend.domain.dutchpay.service;

import java.util.List;
import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.PaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.RegisterPaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayDetailResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayRoomResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.PaymentResponseDto;

public interface DutchpayService {

  DutchpayRoomResponseDto createDutchpayRoom(String loginId, DutchpayRoomRequestDto request);

  List<DutchpayRoomResponseDto> getDutchpayRooms(String loginId);

  List<PaymentResponseDto> getPayments(String loginId, int dutchpayRoomId);

  void registerPayments(String loginId, RegisterPaymentRequestDto request);

  List<DutchpayDetailResponseDto> getDutchpayRoom(String loginId, int roomId);

  PaymentResponseDto viewPayments(String loginId, PaymentRequestDto request);
}
