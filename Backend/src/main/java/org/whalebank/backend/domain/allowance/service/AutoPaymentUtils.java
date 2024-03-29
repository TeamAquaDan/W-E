package org.whalebank.backend.domain.allowance.service;

import jakarta.transaction.Transactional;
import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.whalebank.backend.domain.account.dto.request.WithdrawRequestDto;
import org.whalebank.backend.domain.account.service.AccountService;
import org.whalebank.backend.domain.allowance.AutoPaymentEntity;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.repository.AutoPaymentRepository;
import org.whalebank.backend.domain.notification.FCMCategory;
import org.whalebank.backend.domain.notification.dto.request.FCMRequestDto;
import org.whalebank.backend.domain.notification.service.FcmUtils;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;

@Component
@RequiredArgsConstructor
@Transactional
public class AutoPaymentUtils {

  private final AutoPaymentRepository autoPaymentRepository;
  private final AccountService accountService;
  private final FcmUtils fcmUtils;

  @Scheduled(cron = "0 28 17 * * *")
  public void allowanceAutoPayment() {
    // 오늘 날짜에 해당하는 자동이체만 가져와서
    LocalDate today = LocalDate.now();
    List<AutoPaymentEntity> entities =
        autoPaymentRepository.findAllByScheduledDate(today);

    for (AutoPaymentEntity entity : entities) {
      GroupEntity group = entity.getGroup();
      // 부모 -> 자녀 송금
      UserEntity parent = findUserByRole(group, Role.ADULT.name());
      accountService.withdraw(parent.getLoginId(), WithdrawRequestDto.of(entity, parent.getUserName()));

      // 푸시 알림 전송
      UserEntity child = findUserByRole(group, Role.CHILD.name());
      System.out.println("용돈 보내는 사람: "+parent.getUserId()+"번, "+parent.getUserName());
      System.out.println("용돈 받는 사람: "+child.getUserId()+"번, "+child.getUserName());
      System.out.println("송금 금액: "+entity.getReservedAmt());

      fcmUtils.sendNotificationByToken(child,
          FCMRequestDto.of("용돈을 받았어요!", parent.getUserName() + "님께서 용돈을 보냈어요!",
              FCMCategory.DEPOSIT));
      fcmUtils.sendNotificationByToken(parent,
          FCMRequestDto.of("용돈을 보냈어요!", child.getUserName() + "님께 용돈을 보냈어요!",
              FCMCategory.WITHDRAW));

      // 다음 이체 날짜 변경
      entity.calculateNextAutoPaymentDate(group.isMonthly(),
          (group.isMonthly()) ? group.getDayOfMonth() : group.getDayOfWeek());
    }

  }

  private UserEntity findUserByRole(GroupEntity group, String role) {
    return group.getMemberEntityList().stream()
        .filter(m -> m.getRole().equals(role))
        .findFirst()
        .get()
        .getUser();
  }

}
