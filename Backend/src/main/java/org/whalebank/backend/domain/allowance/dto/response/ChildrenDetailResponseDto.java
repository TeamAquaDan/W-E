package org.whalebank.backend.domain.allowance.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.user.UserEntity;

@Getter
@Setter
@Builder
public class ChildrenDetailResponseDto {

  public int user_id;
  public int group_id;
  public String account_num; // 자녀 계좌번호
  public boolean is_monthly; // boolean, 용돈 주기
  public int allowance_amt; // 용돈 금액
  public int payment_date;  // 용돈 지급일

  public static ChildrenDetailResponseDto of(GroupEntity group, UserEntity user) {
    return ChildrenDetailResponseDto.builder()
        .user_id(user.getUserId())
        .group_id(group.getGroupId())
        .account_num(user.getAccountNum())
        .is_monthly(group.isMonthly())
        .allowance_amt(group.getAllowanceAmt())
        .payment_date(group.isMonthly() ? group.getDayOfMonth() : group.getDayOfWeek())
        .build();
  }

}
