package org.whalebank.backend.global.openfeign.bank;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.whalebank.backend.domain.user.UserEntity;
import org.whalebank.backend.global.exception.CustomException;
import org.whalebank.backend.global.openfeign.bank.request.CheckUserRequestDto;
import org.whalebank.backend.global.openfeign.bank.response.CheckUserResponseDto;
import org.whalebank.backend.global.response.ResponseCode;

@Service
@RequiredArgsConstructor
@Slf4j
public class BankAccessUtil {

  private final BankClient bankClient;

  public String getUserInfo(String userCI) {
    CheckUserResponseDto userResponseDto = bankClient.getUser(new CheckUserRequestDto(userCI))
        .getBody();

    if(userResponseDto == null) {
      // 은행에 유저가 존재하지 않음
      throw new CustomException(ResponseCode.BANK_USER_NOT_FOUND);
    }

    return userResponseDto.getPhone_num();
  }

}
