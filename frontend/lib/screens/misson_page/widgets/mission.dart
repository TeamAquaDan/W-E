import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Mission extends StatelessWidget {
  const Mission({
    super.key,
    required this.missionStatus,
    required this.missionName,
    required this.missionReward,
    required this.deadlineDate,
    required this.userName,
  });

  final int missionStatus;
  final String missionName;
  final int missionReward;
  final String deadlineDate;
  final String userName;

  String formatDeadlineDate(String deadlineDate) {
    // 문자열을 DateTime 객체로 파싱합니다.
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(deadlineDate);
    // DateTime 객체를 원하는 형식의 문자열로 변환합니다.
    return DateFormat('yy.MM.dd').format(dateTime);
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    // deadline_date를 DateTime 객체로 파싱
    DateTime deadline = DateTime.parse(deadlineDate);
    // 현재 날짜
    DateTime now = DateTime.now();
    // D-Day 계산
    int dDay =
        deadline.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (missionStatus == 0) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7A97FF),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
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
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '~${formatDeadlineDate(deadlineDate)}',
                          style: const TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${formatNumber(missionReward)}원',
                      style: const TextStyle(
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
      Color missionColor = missionStatus == 1 ? Colors.green : Colors.red;
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: missionColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDeadlineDate(deadlineDate),
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${formatNumber(missionReward)}원',
                      style: const TextStyle(
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
