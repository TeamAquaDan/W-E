package org.whalebank.backend.domain.goal.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Builder
public class GoalListResponseDto {

  private List<Goal> goal_list;

  @Getter
  @Setter
  @NoArgsConstructor
  @AllArgsConstructor
  @Builder
  public static class Goal {

    private int goal_id;    // 목표 아이디
    private String goal_name;    // 목표 이름
    private int goal_amt;    // 목표 금액
    private int status; // 진행(0), 성공(1), 실패(2)
    private String start_date;  // 시작일
    private String withdraw_date;   // 출금일
    private String goal_date;    // 마감일
    private int percentage; // 달성률
    private int withdraw_amt;  // 출금한 저축 금액
  }
}
