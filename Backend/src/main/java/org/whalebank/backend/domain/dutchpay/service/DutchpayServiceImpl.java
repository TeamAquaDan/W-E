package org.whalebank.backend.domain.dutchpay.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;
import org.whalebank.backend.domain.dutchpay.SelectedPaymentEntity;
import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.PaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.PaymentRequestDto.Transaction;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayRoomResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.PaymentResponseDto;
import org.whalebank.backend.domain.dutchpay.repository.DutchpayRepository;
import org.whalebank.backend.domain.dutchpay.repository.DutchpayRoomRepository;
import org.whalebank.backend.domain.dutchpay.repository.SelectedPaymentRepository;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.card.CardAccessUtil;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
public class DutchpayServiceImpl implements DutchpayService {

  private final AuthRepository authRepository;
  private final DutchpayRepository dutchpayRepository;
  private final DutchpayRoomRepository dutchpayRoomRepository;
  private final SelectedPaymentRepository selectedPaymentRepository;
  private final CardAccessUtil cardAccessUtil;

  @Override
  public DutchpayRoomResponseDto createDutchpayRoom(String loginId,
      DutchpayRoomRequestDto request) {

    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    List<String> profileImg = new ArrayList<>();

    // 방장 프로필 사진 추가
    profileImg.add(user.getProfile().getProfileImage());

    // 더치페이 방 생성
    DutchpayRoomEntity dutchpayRoom = DutchpayRoomEntity.createRoom(request,
        user);

    DutchpayEntity dutchpayManager = DutchpayEntity.createRoom(user, dutchpayRoom);

    dutchpayRoomRepository.save(dutchpayRoom);
    dutchpayRepository.save(dutchpayManager);

    // 초대한 친구에게 모두 더치페이 만들기
    for (int userId : request.getMembers()) {
      UserEntity member = authRepository.findById(userId)
          .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

      if (user.equals(member)) {
        throw new CustomException(ResponseCode.CANNOT_ADD_SELF);
      }

      profileImg.add(member.getProfile().getProfileImage());

      DutchpayEntity dutchpay = DutchpayEntity.createRoom(member, dutchpayRoom);

      dutchpayRepository.save(dutchpay);
    }

    // 요청으로 들어온 친구 목록의 프로필 사진이 리턴값에 포함
    return DutchpayRoomResponseDto.from(dutchpayRoom, profileImg);
  }

  @Override
  public List<DutchpayRoomResponseDto> getDutchpayRooms(String loginId) {
    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    List<DutchpayEntity> dutchpayList = dutchpayRepository.findByUser(user);

    return dutchpayList.stream()
        .map(dutchpay -> {
          DutchpayRoomEntity dutchpayRoom = dutchpay.getRoom();
          List<String> profileImg = dutchpayRepository.findByRoom(dutchpayRoom).stream()
              .map(userProfile -> userProfile.getUser().getProfile().getProfileImage())
              .collect(Collectors.toList());
          return DutchpayRoomResponseDto.from(dutchpay.getRoom(), profileImg);
        })
        .collect(Collectors.toList());
  }

  @Override
  public List<PaymentResponseDto> getPayments(String loginId, int dutchpayRoomId) {

    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(dutchpayRoomId)
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    LocalDate targetDate = dutchpayRoom.getDutchpayDate();

    return cardAccessUtil.getCardHistory(
            user.getCardAccessToken(), targetDate.atStartOfDay()).getPay_list()
        .stream()
        .filter(detail -> {
          LocalDateTime transactionDateTime = detail.getTransaction_dtm();
          return !transactionDateTime.isAfter(targetDate.plusDays(1).atStartOfDay());
        })
        .map(detail -> PaymentResponseDto.builder()
            .trans_id(detail.getTrans_id())
            .member_store_name(detail.getMember_store_name())
            .trans_amt(detail.getTrans_amt())
            .category(PaymentResponseDto.convertCodetoCategory(detail.getMember_store_type()))
            .build())
        .collect(Collectors.toList());
  }

  @Override
  public void registerPayments(String loginId, PaymentRequestDto request) {

    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(request.getRoom_id())
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    DutchpayEntity dutchpay = dutchpayRepository.findByUserAndRoom(user, dutchpayRoom);

    int totalAmt = 0;

    for (Transaction transaction : request.getTransactions()) {
      selectedPaymentRepository
          .save(SelectedPaymentEntity.from(dutchpay, transaction));

      totalAmt += transaction.getTransAmt();
    }

    dutchpay.setAccountId(request.getAccount_id());
    dutchpay.setAccountNum(request.getAccount_num());
    dutchpay.setAccountPassword(request.getPassword());
    dutchpay.setTotalAmt(totalAmt);

    dutchpayRepository.save(dutchpay);
  }
}
