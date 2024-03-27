import 'package:flutter/material.dart';
import 'package:frontend/screens/saving_goal_page/my_saving_goal_form.dart';

class SavingGoalPlus extends StatelessWidget {
  const SavingGoalPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 12),
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 88, 163, 209),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
            children: [
              const Text(
                '목표를 추가해주세요!',
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
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          // return const MySavingGoalForm(); // BottomSheet로 MySavingGoalForm을 표시
                          return const MySavingGoalForm();
                        },
                      );
                    },
                    icon: const Icon(Icons.add_circle_rounded),
                    color: Colors.black54,
                    iconSize: 45,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
