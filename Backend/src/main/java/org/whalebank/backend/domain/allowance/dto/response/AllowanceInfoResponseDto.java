package org.whalebank.backend.domain.allowance.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.allowance.GroupEntity;
import org.whalebank.backend.domain.allowance.RoleEntity;

@Getter
@Setter
@Builder
public class AllowanceInfoResponseDto {

  public boolean is_monthly;
  public int allowance_amt;// 용돈 금액
  public int payment_date; // 용돈 지급일
  public String group_nickname; // 그룹 별칭
  public int group_id;     // 그룹 아이디
  public int user_id;      // 부모 아이디
  public String user_name; // 부모 이름

  public static AllowanceInfoResponseDto from(RoleEntity entity) {
    GroupEntity group = entity.getUserGroup();
    return AllowanceInfoResponseDto.builder()
        .is_monthly(group.isMonthly())
        .allowance_amt(group.getAllowanceAmt())
        .payment_date(group.isMonthly()?group.getDayOfMonth():group.getDayOfWeek())
        .group_nickname(entity.getGroupNickname())
        .group_id(group.getGroupId())
        .user_id(entity.getUser().getUserId())
        .user_name(entity.getUser().getUserName())
        .build();
  }

}
