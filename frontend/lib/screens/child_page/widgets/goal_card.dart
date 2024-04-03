import 'package:flutter/material.dart';
import 'package:frontend/api/save/goal_list_api.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_detail.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_plus.dart';
import 'package:get/get.dart';

class GoalCard extends StatefulWidget {
  const GoalCard({super.key});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  late List<Map<String, dynamic>> mySavingGoals = []; // 여기에 API 응답 데이터를 저장합니다.

  @override
  void initState() {
    super.initState();
    loadSavingGoals(); // initState에서 데이터 로딩을 시작합니다.
  }

  Future<void> loadSavingGoals() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var goalList = await getGoalList(3);
    setState(() {
      if (goalList != null) {
        mySavingGoals = goalList;
        // API로부터 받아온 데이터를 상태에 저장합니다.
      } else {
        mySavingGoals = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 진행중인 목표 (status가 0인 경우)
    List<dynamic> currentGoals =
        mySavingGoals.where((goal) => goal['status'] == 0).toList();

    List<Widget> currentGoalWidgets = currentGoals.map<Widget>((goal) {
      return InkWell(
        onTap: () {
          Get.to(() => SavingGoalDetail(
                goalId: goal['goal_id'],
              ));
        },
        child: SavingGoal(
          goalId: goal['goal_id'],
          goalName: goal['goal_name'] ?? '',
          goalAmt: goal['goal_amt'],
          status: goal['status'],
          startDate: goal['start_date'] ?? '',
          withdrawDate: goal['withdraw_date'] ?? '',
          goalDate: goal['end_date'] ?? '',
          percentage: goal['percentage'],
          withdrawAmt: goal['withdraw_amt'],
          category: goal['category'] ?? '',
          savedAmt: goal['saved_amt'],
        ),
      );
    }).toList();

    // 진행중 목표 비었을 시 widget 추가
    if (currentGoals.isEmpty) {
      currentGoalWidgets.add(SavingGoalPlus(
        onAddGoal: loadSavingGoals,
      ));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...currentGoalWidgets,
        ],
      ),
    );
  }
}
