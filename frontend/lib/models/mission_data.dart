/*
"{
  ""status"": 200,
  ""message"": ""미션 목록 조회 성공"", 
  ""data"": [
     {
         ""mission_id"" : ""int, 미션 아이디"",
         ""mission_name"": ""string, 미션 제목"",
         ""mission_reward"": ""int, 보상금액"", 
         ""deadline_date"": ""string, 마감 일시날짜(yyyy-mm-dd)"",
         ""status"": ""int, 처리 상태"",
         ""user_name"" : ""string, 미션 제공자 이름""
     },
  ]
}
처리상태 0(진행중), 1(성공), 2(실패)"
 */

import 'package:flutter/material.dart';
//flutter pub add uuid
import 'package:uuid/uuid.dart';
//flutter pub add intl
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

class MissionData {
  MissionData({
    required this.mission_id,
    required this.mission_name,
    required this.mission_reward,
    required this.deadline_date,
    required this.status,
    required this.user_name,
    // this.date,
  });

  final int mission_id;
  final String mission_name;
  final int mission_reward;
  final String deadline_date;
  final int status;
  final String user_name;

  // String get formattedDate {
  //   return formatter.format(date);
  // }
}
