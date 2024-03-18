import 'package:flutter/material.dart';

class SavingGoal extends StatefulWidget {
  const SavingGoal({super.key});
  @override
  State<SavingGoal> createState() => _SavingGoal();
}

class _SavingGoal extends State<SavingGoal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF97D8FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    '💻',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '갤럭시 탭 S9',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40), // 제목과 진행 바 사이의 간격
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '현재 금액',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '1,000,000원',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '목표 금액',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '1,360,000원',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // 진행 바 상단의 간격
              Stack(
                children: [
                  Container(
                    width: 350, // 전체 길이
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F9FB),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Container(
                    width: 350 / 100 * 70, // 진행 백분율 길이
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF46A1F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5), // 진행 바와 백분율 사이의 간격
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '70%',
                  style: TextStyle(
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
    );
  }
}
