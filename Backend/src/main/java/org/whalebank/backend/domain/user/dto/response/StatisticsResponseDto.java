package org.whalebank.backend.domain.user.dto.response;

import java.util.Map;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class StatisticsResponseDto {

  private int expense_amt;  // 지출 총액

  private Map<String, Integer> statistics_list; // 통계 내역

}
