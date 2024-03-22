import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingGoal extends StatelessWidget {
  const SavingGoal({
    super.key,
    required this.goalId,
    required this.goalName,
    required this.goalAmt,
    required this.status,
    required this.startDate,
    required this.withdrawDate,
    required this.endDate,
    required this.percentage,
    required this.savedAmt,
  });

  final int goalId;
  final String goalName;
  final int goalAmt;
  final int status;
  final String startDate;
  final String withdrawDate;
  final String endDate;
  final double percentage;
  final int savedAmt;

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  Color formatColor(int status) {
    if (status == 1) {
      return const Color.fromARGB(255, 104, 178, 101);
    } else {
      return const Color.fromARGB(255, 211, 106, 106);
    }
  }

  @override
  Widget build(BuildContext context) {
    return status == 0
        ? Column(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xff97d8ff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          goalName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // 제목과 진행 바 사이의 간격
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '현재 금액',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${formatNumber(savedAmt)} 원',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '목표 금액',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${formatNumber(goalAmt)} 원',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // 진행 바 상단의 간격
                    LinearProgressIndicator(
                      value: percentage / 100, // 70% 진행
                      backgroundColor: const Color(0xFFF4F9FB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF46A1F5)),
                      minHeight: 5,
                    ),
                    const SizedBox(height: 5), // 진행 바와 백분율 사이의 간격
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$percentage%',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Column(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: formatColor(status),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalName,
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
                        const Text(
                          '인출 금액',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$savedAmt 원',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '목표 금액',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$goalAmt 원',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '인출 날짜',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          withdrawDate,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
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
