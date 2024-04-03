package org.whalebank.backend.domain.account.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.whalebank.backend.global.openfeign.bank.response.InquiryResponse;

@Getter
@Setter
@Builder
public class InquiryResponseDto {

  public String bank_name;
  public String account_num;
  public String[] account_holder_name;

  public static InquiryResponseDto from(InquiryResponse inquiryResponse) {
    return InquiryResponseDto.builder()
        .bank_name(inquiryResponse.getBank_name())
        .account_num(inquiryResponse.getAccount_num())
        .account_holder_name(inquiryResponse.getAccount_holder_name().split(" "))
        .build();
  }

}
