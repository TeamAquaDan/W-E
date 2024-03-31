package org.whalebank.backend.domain.notification;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public enum FCMCategory {

  // 친구 요청
  FRIEND_REQUEST_RECEIVED("100", "친구 요청 수신"),
  FRIEND_REQUEST_ACCEPTED("101", "친구 요청이 승인됨"),

  // 입출금
  DEPOSIT("200", "입금"),
  WITHDRAW("201", "출금"),

  // 미션
  MISSION_ADDED("300", "새로운 미션이 등록됨"),
  MISSION_RESULT("301", "미션이 처리됨"),

  // 인상 요청
  INCREASE_REQUEST("400", "인상 요청이 등록됨"),
  INCREASE_REQUEST_RESULT("401", "인상 요청이 처리됨"),

  // 그룹
  PARENT_ADD_CHILD("700", "부모가 자녀를 추가함"),

  // 더치페이
  DUTCHPAY_ROOM_CREATE("500", "더치페이 방에 입장함"),
  START_DUTCHPAY("501", "정산하기를 눌러 정산을 완료해보세요"),
  DUTCHPAY_COMPLETED("502", "더치페이 완료");

  public final String code;
  public final String description;
}
