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
          // width: 330,
          // height: 123,
          decoration: ShapeDecoration(
            color: Color(0xFF97D8FF), // 배경색 변경
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          margin: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
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
              SizedBox(height: 40), // 제목과 진행 바 사이의 간격
              Row(
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
              Row(
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
              SizedBox(height: 10), // 진행 바 상단의 간격
              Stack(
                children: [
                  Container(
                    width: 282,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F9FB),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Container(
                    width: 218, // 진행 상태에 따라 변경 가능
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFF46A1F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5), // 진행 바와 백분율 사이의 간격
              Align(
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
