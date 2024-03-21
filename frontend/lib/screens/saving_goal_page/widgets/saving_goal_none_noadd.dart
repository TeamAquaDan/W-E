import 'package:flutter/material.dart';

class SavingGoalNoneNoadd extends StatelessWidget {
  const SavingGoalNoneNoadd({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 12),
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: BoxDecoration(
            color: const Color(0xFF97D8FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
            children: [
              const Text(
                '아직 저축 목표가 없어요!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/whale.png',
                    width: 55,
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }
}
