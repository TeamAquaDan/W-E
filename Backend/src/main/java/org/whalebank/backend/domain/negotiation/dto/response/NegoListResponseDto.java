package org.whalebank.backend.domain.negotiation.dto.response;

import java.time.format.DateTimeFormatter;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.domain.negotiation.NegotiationEntity;

@Getter
@Setter
@Builder
public class NegoListResponseDto {

  public int nego_id;
  public int nego_amt;
  public String create_dtm;
  public String completed_dtm;
  public int status; // 0(대기중), 1(승인), 2(거절)
  public String comment; // 승인/거절 사유
  public int allowance_amt; // 요청 당시 용돈 금액
  public String nego_reason; // 용돈 인상 요청 이유

  public static NegoListResponseDto from(NegotiationEntity entity) {
    return NegoListResponseDto.builder()
        .nego_id(entity.getNegoId())
        .nego_amt(entity.getNegoAmt())
        .create_dtm(entity.getCreateDtm().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")))
        .completed_dtm((entity.getStatus()==0) ? null : entity.getCompletedDtm().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")))
        .status(entity.getStatus())
        .comment((entity.getStatus()==0) ? null : entity.getNegoComment())
        .allowance_amt(entity.getCurrentAllowanceAmt())
        .nego_reason(entity.getNegoReason())
        .build();
  }

}
