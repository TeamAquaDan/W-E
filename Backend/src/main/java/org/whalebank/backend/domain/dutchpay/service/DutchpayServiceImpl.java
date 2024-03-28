package org.whalebank.backend.domain.dutchpay.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.dutchpay.CategoryCalculateEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;
import org.whalebank.backend.domain.dutchpay.SelectedPaymentEntity;
import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.PaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.RegisterPaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.RegisterPaymentRequestDto.Transaction;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayDetailResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayRoomResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.PaymentResponseDto;
import org.whalebank.backend.domain.dutchpay.repository.CategoryCalculateRepository;
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
  private final CategoryCalculateRepository categoryCalculateRepository;
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
  public void registerPayments(String loginId, RegisterPaymentRequestDto request) {

    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(request.getRoom_id())
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    DutchpayEntity dutchpay = dutchpayRepository.findByUserAndRoom(user, dutchpayRoom);

    int totalAmt = 0;

    for (Transaction transaction : request.getTransactions()) {
      selectedPaymentRepository
          .save(SelectedPaymentEntity.from(dutchpay, transaction));

      totalAmt += transaction.getTrans_amt();
    }

    dutchpay.setAccountId(request.getAccount_id());
    dutchpay.setAccountNum(request.getAccount_num());
    dutchpay.setAccountPassword(request.getPassword());
    dutchpay.setTotalAmt(totalAmt);

    dutchpayRoom.setSetAmtCount(dutchpayRoom.getSetAmtCount() + 1);

    dutchpayRepository.save(dutchpay);
  }

  @Override
  public List<DutchpayDetailResponseDto> getDutchpayRoom(String loginId, int roomId) {

    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(roomId)
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    List<DutchpayEntity> dutchpayList = dutchpayRepository.findByRoom(dutchpayRoom);

    return dutchpayList.stream()
        .map(DutchpayDetailResponseDto::from)
        .collect(Collectors.toList());
  }

  @Override
  public List<PaymentResponseDto> viewPayments(String loginId, PaymentRequestDto request) {

    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(request.getRoom_id())
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    DutchpayEntity dutchpay = dutchpayRepository.findByDutchpayIdAndRoom(request.getDutchpay_id(),
        dutchpayRoom);

    List<SelectedPaymentEntity> payment = selectedPaymentRepository.findByDutchpay(dutchpay);

    return payment.stream()
        .map(PaymentResponseDto::from)
        .collect(Collectors.toList());
  }

  @Override
  public List<DutchpayDetailResponseDto> autoDutchpay(String loginId, int roomId) {

    // 로그인한 유저
    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 정산할 더치페이 방
    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(roomId)
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    // 로그인한 유저가 방장이 아닌 경우
    // 403: 정산하기 권한이 없습니다
    if (dutchpayRoom.getManagerId() != user.getUserId()) {
      throw new CustomException(ResponseCode.AUTO_DUTCHPAY_ACCESS_DENIED);
    }

    // 더치페이 방에 등록된 더치페이 리스트
    List<DutchpayEntity> dutchpayList = dutchpayRepository.findByRoom(dutchpayRoom);

    // 미등록 인원이 있는 경우
    // 400: 모든 멤버가 금액을 등록해야 합니다.
    if (dutchpayRoom.getSetAmtCount() != dutchpayList.size()) {
      throw new CustomException(ResponseCode.UNREGISTERED_MEMBERS);
    }

    // 더치페이 방에 등록된 모든 결제 내역 리스트
    List<SelectedPaymentEntity> selectedPaymentList = selectedPaymentRepository.findByRoomId(
        dutchpayRoom.getRoomId());

    // 카테고리별 정산 함수
    categoryCalculate(selectedPaymentList);

    // 개인별 정산 금액 계산하는 함수

    // 잔액이 정산금액보다 많으면 이체하기

    // 이체 내역 가계부에 등록 및 선택한 내역 가계부에서 숨기기

    return null;
  }

  private void categoryCalculate(List<SelectedPaymentEntity> selectedPaymentList) {

    for (SelectedPaymentEntity selectedPayment : selectedPaymentList) {

      String category = selectedPayment.getCategory();

      CategoryCalculateEntity categoryCalculate = categoryCalculateRepository.findByCategory(
          category);

      // CategoryCalculate Entity를 선택한 내역의 "카테고리"로 찾는다
      // 존재하지 않으면 새로 만든다
      // 존재하면 기존 totalAmt 값에 현재 선택 내역의 결제 금액을 더해준다
      if (categoryCalculate == null) {
        categoryCalculateRepository.save(CategoryCalculateEntity.create(selectedPayment));
      } else {
        categoryCalculate.setTotalAmt(
            categoryCalculate.getTotalAmt() + selectedPayment.getTransAmt());
        categoryCalculateRepository.save(categoryCalculate);
      }
    }
  }

}

