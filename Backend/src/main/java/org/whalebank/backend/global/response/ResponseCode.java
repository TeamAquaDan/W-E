package org.whalebank.backend.global.response;

import com.google.api.Http;
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
  ALREADY_MAIN_ACCOUNT(HttpStatus.CONFLICT.value(), "이미 주계좌로 등록된 계좌입니다"),
  WRONG_LOGIN_PASSWORD(HttpStatus.UNAUTHORIZED.value(), "비밀번호가 일치하지 않습니다"),
  USER_ALREADY_SIGNUP(HttpStatus.CONFLICT.value(), "이미 등록된 계정입니다."),
  MAIN_ACCOUNT_NOT_REGISTERED(HttpStatus.NOT_FOUND.value(), "주계좌가 등록되어 있지 않습니다"),

  // 친구
  FRIENDSHIP_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "친구 요청이 존재하지 않습니다"),
  INVALID_FRIENDSHIP_REQ(HttpStatus.BAD_REQUEST.value(), "요청 값이 올바르지 않습니다"),
  FRIEND_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "친구 관계가 아닙니다"),
  ALREADY_FRIEND(HttpStatus.CONFLICT.value(), "이미 친구로 등록된 사용자입니다"),

  // 은행
  BANK_USER_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "은행 고객이 아닙니다"),
  ACCOUNT_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "계좌가 존재하지 않습니다"),
  WRONG_ACCOUNT_PASSWORD(HttpStatus.UNAUTHORIZED.value(), "계좌 비밀번호가 올바르지 않습니다"),
  INSUFFICIENT_BALANCE(HttpStatus.BAD_REQUEST.value(), "잔액이 부족합니다"),
  TRANSFER_LIMIT_EXCEEDED(HttpStatus.BAD_REQUEST.value(), "이체 한도가 초과되었습니다"),
  DUPLICATE_TRANSFER_FORBIDDEN(HttpStatus.CONFLICT.value(), "동일한 계좌로의 이체는 허용되지 않습니다"),

  // 가계부
  INVALID_TIME_FORMAT(HttpStatus.BAD_REQUEST.value(), "해당 월은 존재하지 않습니다"),
  ACCOUNT_BOOK_ENTRY_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "지출/수입 내역을 찾을 수 없습니다"),

  // 목표
  ALREADY_EXIST(HttpStatus.BAD_REQUEST.value(), "이미 목표가 존재하는 계좌입니다."),

  // JWT
  JWT_EXPIRED(HttpStatus.UNAUTHORIZED.value(), "토큰이 만료되었습니다."),
  JWT_MALFORMED(HttpStatus.UNAUTHORIZED.value(), "손상된 토큰입니다."),
  JWT_UNSUPPORTED(HttpStatus.UNAUTHORIZED.value(), "지원하지 않는 토큰입니다."),
  JWT_SIGNATURE(HttpStatus.UNAUTHORIZED.value(), "검증에 실패한 토큰입니다"),
  JWT_ILLEGALARGUMENT(HttpStatus.UNAUTHORIZED.value(), "관리자에게 문의해주세요"),
  JWT_NULL(HttpStatus.UNAUTHORIZED.value(), "토큰이 필요합니다"),

  // 그룹, 역할
  GROUP_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "부모-자녀 그룹이 존재하지 않습니다"),
  GROUP_EDIT_FORBIDDEN(HttpStatus.FORBIDDEN.value(), "그룹 수정 권한이 없습니다"),
  GROUP_ROLE_NOT_FOUND(HttpStatus.FORBIDDEN.value(), "그룹에 소속되어 있지 않습니다"),
  USER_VIEW_FORBIDDEN(HttpStatus.FORBIDDEN.value(), "해당 유저에 대한 조회 권한이 없습니다"),
  ALREADY_ADDED_CHILD(HttpStatus.CONFLICT.value(), "이미 추가된 자녀입니다"),

  // 더치페이
  CANNOT_ADD_SELF(HttpStatus.BAD_REQUEST.value(), "본인은 자동 추가되기 때문에 추가할 수 없습니다"),
  DUTCHPAY_ROOM_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "더치페이 방이 존재하지 않습니다"),
  DUTCHPAY_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "더치페이가 존재하지 않습니다"),
  AUTO_DUTCHPAY_ACCESS_DENIED(HttpStatus.FORBIDDEN.value(), "자동정산 권한이 없습니다"),
  UNREGISTERED_MEMBERS(HttpStatus.BAD_REQUEST.value(), "아직 내역을 등록하지 않은 인원이 있습니다"),
  ALREADY_REGISTERED(HttpStatus.BAD_REQUEST.value(), "이미 등록한 내역입니다"),
  DUTCHPAY_FINISHED(HttpStatus.BAD_REQUEST.value(), "이미 더치페이가 완료된 방입니다"),
  SELF_DUTCHPAY_ACCESS_DENIED(HttpStatus.FORBIDDEN.value(), "수동정산 권한이 없습니다"),

  // 알림
  NOTI_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "알림이 존재하지 않습니다"),
  NOTI_ACCESS_DENIED(HttpStatus.FORBIDDEN.value(), "알림 접근 권한이 없습니다"),
  NOTI_SEND_FAIL(HttpStatus.INTERNAL_SERVER_ERROR.value(), "알림 전송에 실패했습니다"),
  FIREBASE_SETTING_FAIL(HttpStatus.INTERNAL_SERVER_ERROR.value(), "파이어베이스 세팅 실패"),

  // 미션
  MISSION_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "미션이 존재하지 않습니다"),

  // 인상 요청
  NEGO_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "존재하지 않는 요청입니다"),


  // 프로필
  SAME_USER(HttpStatus.BAD_REQUEST.value(), "작성자가 프로필 사용자와 동일한 사용자입니다"),
  PROFILE_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "프로필을 찾을 수 없습니다"),
  GUESTBOOK_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "방명록을 찾을 수 없습니다"),
  NO_DELETE_PERMISSION(HttpStatus.FORBIDDEN.value(), "삭제 권한이 없는 사용자입니다");


  private final int code;
  private final String message;

}
