import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Mission extends StatelessWidget {
  const Mission(
      {super.key,
      required this.mission_status,
      required this.mission_name,
      required this.mission_reward,
      required this.deadline_date,
      required this.user_name});

  final int mission_status;
  final String mission_name;
  final int mission_reward;
  final String deadline_date;
  final String user_name;

  String formatDeadlineDate(String deadlineDate) {
    // 문자열을 DateTime 객체로 파싱합니다.
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(deadlineDate);
    // DateTime 객체를 원하는 형식의 문자열로 변환합니다.
    return DateFormat('yy.MM.dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // deadline_date를 DateTime 객체로 파싱
    DateTime deadline = DateTime.parse(deadline_date);
    // 현재 날짜
    DateTime now = DateTime.now();
    // D-Day 계산
    int dDay =
        deadline.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (mission_status == 0) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF7A97FF),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.fromLTRB(16, 18, 16, 0),
            padding: EdgeInsets.symmetric(horizontal: 19, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission_name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'D-$dDay ',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          formatDeadlineDate(deadline_date),
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$mission_reward원',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      Color mission_color = mission_status == 1 ? Colors.green : Colors.red;
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: mission_color,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.fromLTRB(16, 18, 16, 0),
            padding: EdgeInsets.symmetric(horizontal: 19, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission_name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDeadlineDate(deadline_date),
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$mission_reward원',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
