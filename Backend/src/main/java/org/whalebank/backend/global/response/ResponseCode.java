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
  USER_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "유저가 존재하지 않습니다"),
  INVALID_REFRESH_TOKEN(HttpStatus.UNAUTHORIZED.value(), "리프레시 토큰 정보가 유효하지 않습니다"),
  DIFFERENT_REFRESH_TOKEN(HttpStatus.UNAUTHORIZED.value(), "리프레시 토큰이 일치하지 않습니다"),

  // 친구
  FRIENDSHIP_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "친구 요청이 존재하지 않습니다"),
  INVALID_FRIENDSHIP_REQ(HttpStatus.BAD_REQUEST.value(), "요청 값이 올바르지 않습니다"),
  FRIEND_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "친구 관계가 아닙니다"),

  // 은행
  BANK_USER_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "은행 고객이 아닙니다"),
  ACCOUNT_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "계좌가 존재하지 않습니다"),
  WRONG_ACCOUNT_PASSWORD(HttpStatus.UNAUTHORIZED.value(), "계좌 비밀번호가 올바르지 않습니다"),
  INSUFFICIENT_BALANCE(HttpStatus.BAD_REQUEST.value(), "잔액이 부족합니다"),
  TRANSFER_LIMIT_EXCEEDED(HttpStatus.BAD_REQUEST.value(), "이체 한도가 초과되었습니다"),

  ALREADY_EXIST(HttpStatus.BAD_REQUEST.value(), "이미 목표가 존재하는 계좌입니다.");

  private final int code;
  private final String message;

}
