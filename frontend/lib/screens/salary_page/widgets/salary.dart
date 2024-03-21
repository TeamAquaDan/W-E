import 'package:frontend/screens/salary_page/salary_increase_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Salary extends StatelessWidget {
  const Salary({
    super.key,
    required this.isMonthly,
    required this.allowanceAmt,
    required this.paymentDate,
    required this.groupNickname,
    required this.groupId,
    required this.userId,
    required this.userName,
  });

  final bool isMonthly;
  final int allowanceAmt;
  final int paymentDate;
  final String groupNickname;
  final int groupId;
  final int userId;
  final String userName;

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  String getWeekdayName(int day) {
    // 1부터 7까지의 숫자를 요일로 매핑
    const Map<int, String> dayNames = {
      1: '월요일',
      2: '화요일',
      3: '수요일',
      4: '목요일',
      5: '금요일',
      6: '토요일',
      7: '일요일',
    };

    return dayNames[day]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF7A97FF),
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.fromLTRB(16, 18, 16, 0),
          padding: EdgeInsets.fromLTRB(30, 17, 17, 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isMonthly == true
                      ? Text(
                          '매달 $paymentDate일',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Text(
                          '매주 ${getWeekdayName(paymentDate)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    groupNickname,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${formatNumber(allowanceAmt)}원',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => SalaryIncreasePage(),
                        arguments: {},
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFFFEF83),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      '인상요청',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
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
