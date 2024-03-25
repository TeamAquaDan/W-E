import 'package:flutter/material.dart';
import 'package:frontend/api/save/goal_list_api.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_detail.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_none_noadd.dart';
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
    // var fetchedSavingGoals = await fetchSavingGoalsFromAPI();
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

  Future<List<Map<String, dynamic>>> fetchSavingGoalsFromAPI() async {
    return [
      {
        "goal_id": 1,
        "goal_name": "목표 1",
        "goal_amt": 800000,
        "status": 0,
        "start_date": "2024.01.03",
        "withdraw_date": "2024.01.26",
        "end_date": "2024.10.19",
        "percentage": 30.0,
        "saved_amt": 243800
      }
    ];
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
          goalName: goal['goal_name'],
          goalAmt: goal['goal_amt'],
          status: goal['status'],
          startDate: goal['start_date'],
          withdrawDate: goal['withdraw_date'] ?? '',
          endDate: goal['end_date'],
          percentage: goal['percentage'],
          savedAmt: goal['saved_amt'],
        ),
      );
    }).toList();

    // 진행중 목표 비었을 시 widget 추가
    if (currentGoals.isEmpty) {
      currentGoalWidgets.add(const SavingGoalNoneNoadd());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...currentGoalWidgets,
          const SavingGoalPlus(),
        ],
      ),
    );
  }
}
