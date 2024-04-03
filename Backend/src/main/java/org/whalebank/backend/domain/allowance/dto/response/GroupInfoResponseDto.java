package org.whalebank.backend.domain.allowance.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.allowance.GroupEntity;

@Getter
@Setter
@Builder
public class GroupInfoResponseDto {

  public String account_num; // 자녀 계좌번호
  public boolean is_monthly; // 용돈 주기
  public int allowance_amt; // 용돈 금액
  public int payment_date; // 용돈 지급일
  public int group_id; // 그룹 아이디

  public static GroupInfoResponseDto of(GroupEntity group, String childAccountNum) {

    return GroupInfoResponseDto.builder()
        .account_num(childAccountNum) // 자녀 계좌번호
        .is_monthly(group.isMonthly())
        .allowance_amt(group.getAllowanceAmt())
        .payment_date(group.isMonthly()? group.getDayOfMonth():group.getDayOfWeek())
        .group_id(group.getGroupId())
        .build();
  }

}
