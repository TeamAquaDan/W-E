package org.whalebank.whalebank.domain.account.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class PasswordVerifyResponse {

  private int rsp_code;  // 응답코드
  private String rsp_message; // 응답메시지
}
