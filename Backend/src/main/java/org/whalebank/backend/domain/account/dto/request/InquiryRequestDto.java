package org.whalebank.backend.domain.account.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InquiryRequestDto {

  public String bank_code_std;
  public String account_num;

}
