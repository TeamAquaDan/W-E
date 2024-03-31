package org.whalebank.backend.domain.dutchpay.service;

import com.amazonaws.transform.MapEntry;
import jakarta.transaction.Transactional;
import java.sql.SQLOutput;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;
import org.whalebank.backend.domain.account.dto.response.AccountDetailResponseDto;
import org.whalebank.backend.domain.account.service.AccountService;
import org.whalebank.backend.domain.accountbook.AccountBookEntity;
import org.whalebank.backend.domain.accountbook.dto.request.AccountBookEntryRequestDto;
import org.whalebank.backend.domain.accountbook.repository.AccountBookRepository;
import org.whalebank.backend.domain.dutchpay.CategoryCalculateEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayEntity;
import org.whalebank.backend.domain.dutchpay.DutchpayRoomEntity;
import org.whalebank.backend.domain.dutchpay.SelectedPaymentEntity;
import org.whalebank.backend.domain.dutchpay.dto.request.DutchpayRoomRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.PaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.RegisterPaymentRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.request.RegisterPaymentRequestDto.Transaction;
import org.whalebank.backend.domain.dutchpay.dto.request.SelfDutchpayRequestDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayDetailResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.DutchpayRoomResponseDto;
import org.whalebank.backend.domain.dutchpay.dto.response.PaymentResponseDto;
import org.whalebank.backend.domain.dutchpay.repository.CategoryCalculateRepository;
import org.whalebank.backend.domain.dutchpay.repository.DutchpayRepository;
import org.whalebank.backend.domain.dutchpay.repository.DutchpayRoomRepository;
import org.whalebank.backend.domain.dutchpay.repository.SelectedPaymentRepository;
import org.whalebank.backend.domain.notification.FCMCategory;
import org.whalebank.backend.domain.notification.dto.request.FCMRequestDto;
import org.whalebank.backend.domain.notification.service.FcmUtils;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.domain.user.repository.AuthRepository;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.BankAccessUtil;
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
  private final AccountBookRepository accountBookRepository;
  private final CardAccessUtil cardAccessUtil;
  private final BankAccessUtil bankAccessUtil;
  private final AccountService accountService;
  private final FcmUtils fcmUtils;


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

      fcmUtils.sendNotificationByToken(member, FCMRequestDto.of("더치페이 방에 초대되었어요!",
          dutchpayRoom.getDutchpayDate().toString() + " 더치페이 방이 만들어졌어요",
          FCMCategory.INCREASE_REQUEST_RESULT));
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

    // 계좌 비밀번호 확인
    if (!bankAccessUtil.verifyAccountPassword(user.getBankAccessToken(), request.getAccount_id(),
        request.getPassword())) {
      throw new CustomException(ResponseCode.WRONG_ACCOUNT_PASSWORD);
    }

    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(request.getRoom_id())
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    DutchpayEntity dutchpay = dutchpayRepository.findByUserAndRoom(user, dutchpayRoom);

    int totalAmt = 0;

    for (Transaction transaction : request.getTransactions()) {

      // 다른 방에 이미 등록한 내역을 선택한 경우
      if (selectedPaymentRepository.findByTransId(transaction.getTrans_id()) != null) {
        throw new CustomException(ResponseCode.ALREADY_REGISTERED);
      }

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

    if (dutchpayRoom.getSetAmtCount() == dutchpayRepository.findByRoom(dutchpayRoom).size()) {

      UserEntity manager = authRepository.findById(dutchpayRoom.getManagerId())
          .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

      fcmUtils.sendNotificationByToken(manager, FCMRequestDto.of("정산을 시작해볼까요?",
          "모든 멤버들이 " + dutchpayRoom.getDutchpayDate().toString() + " 정산 내역을 등록했어요",
          FCMCategory.START_DUTCHPAY));
    }
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
  @Transactional
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

    // 이미 더치페이가 완료된 경우
    if (dutchpayRoom.isCompleted()) {
      throw new CustomException(ResponseCode.DUTCHPAY_FINISHED);
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
    calculateDutchpayAmount(dutchpayList);

    // 모든 인원이 정산을 완료하면 true
    if (dutchpayRoom.getCompleted_count() == dutchpayList.size()) {

      for (DutchpayEntity dutchpay : dutchpayList) {

        UserEntity member = dutchpay.getUser();

        fcmUtils.sendNotificationByToken(member,
            FCMRequestDto.of("정산이 끝났어요!",
                dutchpayRoom.getDutchpayDate().toString() + " 정산이 완료되었어요",
                FCMCategory.DUTCHPAY_COMPLETED));

      }

      dutchpayRoom.setCompleted(true);
    }

    return dutchpayList.stream()
        .map(DutchpayDetailResponseDto::from)
        .collect(Collectors.toList());

  }

  @Override
  @Transactional
  public List<DutchpayDetailResponseDto> selfDutchpay(String loginId,
      SelfDutchpayRequestDto request, int dutchpayId) {

    // 로그인한 유저
    UserEntity user = authRepository.findByLoginId(loginId)
        .orElseThrow(() -> new CustomException(ResponseCode.USER_NOT_FOUND));

    // 정산할 더치페이
    DutchpayEntity selfDutchpay = dutchpayRepository.findById(dutchpayId)
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_NOT_FOUND));

    // 본인이 아니라면 정산 불가능
    if (user != selfDutchpay.getUser()) {
      throw new CustomException(ResponseCode.SELF_DUTCHPAY_ACCESS_DENIED);
    }

    // 정산할 더치페이 방
    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(
            selfDutchpay.getRoom().getRoomId())
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    // 더치페이 방에 등록된 더치페이 리스트
    List<DutchpayEntity> dutchpayList = dutchpayRepository.findByRoom(dutchpayRoom);

    // 개인별 정산 금액 계산하는 함수
    calculateDutchpayAmount(dutchpayList);

    return dutchpayList.stream()
        .map(DutchpayDetailResponseDto::from)
        .collect(Collectors.toList());
  }

  @Transactional
  public void categoryCalculate(List<SelectedPaymentEntity> selectedPaymentList) {

    for (SelectedPaymentEntity selectedPayment : selectedPaymentList) {

      String category = selectedPayment.getCategory();

      // 선택 내역이 저장되어 있는 더치페이 방
      DutchpayRoomEntity dutchpayRoom = selectedPayment.getDutchpay().getRoom();

      CategoryCalculateEntity categoryCalculate = categoryCalculateRepository.findByCategoryAndRoomId(
          category, dutchpayRoom);

      // CategoryCalculate Entity를 선택한 내역의 "카테고리"로 찾는다
      // 존재하지 않으면 새로 만든다
      // 존재하면 기존 totalAmt 값에 현재 선택 내역의 결제 금액을 더해준다
      if (categoryCalculate == null) {
        categoryCalculateRepository.save(CategoryCalculateEntity.create(selectedPayment,
            dutchpayRoom));
      } else {
        categoryCalculate.setTotalAmt(
            categoryCalculate.getTotalAmt() + selectedPayment.getTransAmt());
        categoryCalculateRepository.save(categoryCalculate);
      }
    }
  }

  @Transactional
  public void calculateDutchpayAmount(List<DutchpayEntity> dutchpayList) {

    // 모든 더치페이를 돌면서 리스트에 dutpayId, totalAmt를 저장한다
    Map<Integer, Integer> eachMemberAmt = new HashMap<>();

    int dutchpayRoomTotalAmt = 0; // 더치페이 방의 총 사용금액

    for (DutchpayEntity dutchpay : dutchpayList) {

      dutchpayRoomTotalAmt += dutchpay.getTotalAmt();

      int spentAmt = dutchpay.getTotalAmt() / dutchpayList.size();  // 사용한 금액 1/N
      eachMemberAmt.put(dutchpay.getDutchpayId(), spentAmt);
    }

    // 인당 사용한 금액
    dutchpayRoomTotalAmt /= dutchpayList.size();

    // 기준이 될 더치페이
    for (DutchpayEntity request : dutchpayList) {

      // 이미 정산 완료라면 넘어감
      if (request.isCompleted()) {
        continue;
      }

      int requestAmt = request.getTotalAmt() / dutchpayList.size();  // 사용한 금액 1/N

      // (인당 총 사용금액 - 사용한 금액)이 계좌 잔액보다 클 경우 잔액 부족
      AccountDetailResponseDto account = accountService.getAccountDetail(
          request.getUser().getLoginId(), request.getAccountId());
      if (dutchpayRoomTotalAmt - requestAmt > account.getBalance_amt()) {
        continue;
      }

      // 잔액이 정산금액보다 많으면 이체하기
      // 다른 금액과 비교
      for (Entry<Integer, Integer> targetAmt : eachMemberAmt.entrySet()) {

        // 본인이면 넘어감
        if (request.getDutchpayId() == targetAmt.getKey()) {
          continue;
        }

        // 돈을 보내야 하는 경우에만 송금
        if (requestAmt < targetAmt.getValue()) {

          DutchpayEntity response = dutchpayRepository.findById(targetAmt.getKey())
              .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_NOT_FOUND));

          sendDutchpayAmount(targetAmt.getValue() - requestAmt, request, response);
        }
      }

      // 이체 완료 -> DutchpayEntity isComplete = true;
      request.setCompleted(true);
      dutchpayRepository.save(request);
      // 정산 완료 인원 + 1
      request.getRoom().setCompleted_count(request.getRoom().getCompleted_count() + 1);

      // 이체 내역 가계부에 등록 및 선택한 내역 가계부에서 숨기기
      hideAndRegister(request, dutchpayList.size());
    }

  }

  @Transactional
  public void sendDutchpayAmount(int tranAmt, DutchpayEntity request, DutchpayEntity response) {

    // 송금할 유저의 아이디
    String requestUserId = request.getUser().getLoginId();

    // WithdrawRequestDto
    WithdrawRequestDto withdrawRequest = WithdrawRequestDto.create(tranAmt, request, response);

    accountService.withdraw(requestUserId, withdrawRequest);
  }


  @Transactional
  public void hideAndRegister(DutchpayEntity dutchpay, int memberCount) {

    List<SelectedPaymentEntity> selectedPaymentList = selectedPaymentRepository.findByDutchpay(
        dutchpay);

    UserEntity user = dutchpay.getUser();

    // 더치페이 방
    DutchpayRoomEntity dutchpayRoom = dutchpayRoomRepository.findById(
            dutchpay.getRoom().getRoomId())
        .orElseThrow(() -> new CustomException(ResponseCode.DUTCHPAY_ROOM_NOT_FOUND));

    // 선택한 결제 내역 가계부에서 숨기기
    for (SelectedPaymentEntity selectedPayment : selectedPaymentList) {
      AccountBookEntity accountBook = accountBookRepository.findByUserAndTransId(
          user, selectedPayment.getTransId());

      accountBook.setHide(true);

      accountBookRepository.save(accountBook);
    }

    // 더치페이 했던 내역 카테고리별 지출내역으로 추가

    // 카테고리별 내역
    List<CategoryCalculateEntity> categoryCalculateList = categoryCalculateRepository.findByRoomId(
        dutchpayRoom);

    for (CategoryCalculateEntity category : categoryCalculateList) {

      int accountBookAmt = category.getTotalAmt() / memberCount;

      AccountBookEntryRequestDto request = AccountBookEntryRequestDto.create(accountBookAmt,
          category, dutchpayRoom);

      AccountBookEntity newAccountBook = AccountBookEntity.createAccountBookEntry(user, request);

      accountBookRepository.save(newAccountBook);
    }

  }

}
