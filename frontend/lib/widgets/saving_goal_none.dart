import 'package:flutter/material.dart';

class SavingGoalNone extends StatelessWidget {
  const SavingGoalNone({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 12),
          margin: const EdgeInsets.all(16),
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
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 1.0), // 오른쪽 패딩
                  child: TextButton(
                    onPressed: () {
                      // 여기에 버튼 클릭 시 실행할 로직을 추가하세요.
                      print('목표 등록하러 가기 클릭됨');
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    child: const Text('목표 등록하러 가기 >'),
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
