package org.whalebank.backend.global.openfeign.bank.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class VerifyResponseDto {

  public int rsp_code;
  public String rsp_message;

}
