package org.whalebank.backend.global.openfeign.bank.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
public class CheckUserRequestDto {

  public String user_ci;

}
