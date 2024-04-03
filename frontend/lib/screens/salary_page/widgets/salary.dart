import 'package:frontend/screens/salary_page/salary_increase_page.dart';
import 'package:frontend/screens/salary_page/widgets/change_nickname_parents.dart';
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
    required this.loadSalarysCallback,
  });

  final bool isMonthly;
  final int allowanceAmt;
  final int paymentDate;
  final String groupNickname;
  final int groupId;
  final int userId;
  final String userName;
  final Function loadSalarysCallback;

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
            color: const Color(0xFF568EF8),
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    groupNickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await showChangeNicknameParentsDialog(context,
                            groupNickname, groupId, loadSalarysCallback);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white60,
                      ))
                ],
              ),
              isMonthly == true
                  ? Text(
                      '매달 $paymentDate일',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Text(
                      '매주 ${getWeekdayName(paymentDate)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${formatNumber(allowanceAmt)} 원',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => SalaryIncreasePage(
                          groupNickname: groupNickname,
                          userName: userName,
                          groupId: groupId,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5FA),
                    ),
                    child: const Text(
                      '용돈 인상',
                      style: TextStyle(
                        color: Color(0xFF3c3c3c),
                        fontSize: 14,
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
