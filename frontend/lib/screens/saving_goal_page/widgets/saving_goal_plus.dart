import 'package:flutter/material.dart';
import 'package:frontend/screens/saving_goal_page/my_saving_goal_form.dart';

class SavingGoalPlus extends StatelessWidget {
  const SavingGoalPlus({super.key, required this.onAddGoal});

  final VoidCallback onAddGoal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 12),
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: BoxDecoration(
            color: const Color(0xff568EF8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
            children: [
              const Text(
                '목표를 추가해주세요!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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
                          return MySavingGoalForm(onAddGoal: onAddGoal);
                        },
                      );
                    },
                    icon: const Icon(Icons.add_circle_rounded),
                    color: Color(0xff1051CE),
                    iconSize: 55,
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
