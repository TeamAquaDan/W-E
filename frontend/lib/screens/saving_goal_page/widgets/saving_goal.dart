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

  @override
  Widget build(BuildContext context) {
    return status == 0
        ? Column(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xff568EF8),
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
                    SizedBox(height: 5), // 상단과 제목 사이의 간격 (상단에는 빈 공간이 있어서 5로 설정
                    Row(
                      children: [
                        Text(
                          goalName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5), // 제목과 진행 바 사이의 간격
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${percentage.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 5), // 백분율과 진행 바 사이의 간격
                    LinearProgressIndicator(
                      value: percentage / 100, // 70% 진행
                      backgroundColor: const Color(0xFFF4F9FB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF46A1F5)),
                      minHeight: 5,
                    ),
                    const SizedBox(height: 10), // 진행 바와 금액 사이의 간격
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '현재 금액',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${formatNumber(savedAmt)} 원',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
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
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${formatNumber(goalAmt)} 원',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // 진행 바 상단의 간격

                    const SizedBox(height: 5), // 진행 바와 백분율 사이의 간격
                  ],
                ),
              ),
            ],
          )
        : Column(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xffE8E8E8),
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
                    SizedBox(height: 5), // 상단과 제목 사이의 간격 (상단에는 빈 공간이 있어서 5로 설정
                    Row(
                      children: [
                        Text(
                          goalName,
                          style: const TextStyle(
                            color: Color(0xff919191),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5), // 제목과 진행 바 사이의 간격
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${percentage.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Color(0xff919191),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 5), // 백분율과 진행 바 사이의 간격
                    LinearProgressIndicator(
                      value: percentage / 100, // 70% 진행
                      backgroundColor: const Color(0xFFF4F9FB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF919191)),
                      minHeight: 5,
                    ),
                    const SizedBox(height: 10), // 진행 바와 금액 사이의 간격
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '현재 금액',
                          style: TextStyle(
                            color: Color(0xff919191),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${formatNumber(savedAmt)} 원',
                          style: const TextStyle(
                            color: Color(0xff919191),
                            fontSize: 14,
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
                            color: Color(0xff919191),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${formatNumber(goalAmt)} 원',
                          style: const TextStyle(
                            color: Color(0xff919191),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // 진행 바 상단의 간격

                    const SizedBox(height: 5), // 진행 바와 백분율 사이의 간격
                  ],
                ),
              ),
            ],
          );
  }
}
