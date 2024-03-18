package org.whalebank.backend.global.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
@Getter
public enum ResponseCode {

  SUCCESS(HttpStatus.OK.value(), "success"),
  BAD_REQUEST(HttpStatus.BAD_REQUEST.value(), "bad request"),
  UNAUTHORIZED(HttpStatus.UNAUTHORIZED.value(), "UnAuthorized"),
  CONFLICT(HttpStatus.CONFLICT.value(), "conflict"),
  INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR.value(), "internal server error"),
  NOT_FOUND(HttpStatus.NOT_FOUND.value(), "not found"),

  // 유저
  INVALID_BIRTHDATE(HttpStatus.BAD_REQUEST.value(), "6자리의 생년월일을 입력해주세요"),
  USER_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "유저가 존재하지 않습니다");

  private final int code;
  private final String message;

}
