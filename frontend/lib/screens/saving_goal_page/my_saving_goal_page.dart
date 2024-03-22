import 'package:flutter/material.dart';
import 'package:frontend/api/save/goal_list_api.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_detail.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_none_noadd.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_plus.dart';
import 'package:get/get.dart';

class MySavingGoalPage extends StatefulWidget {
  const MySavingGoalPage({super.key});

  @override
  State<MySavingGoalPage> createState() => _MySavingGoalPageState();
}

class _MySavingGoalPageState extends State<MySavingGoalPage> {
  late List<Map<String, dynamic>> mySavingGoals = []; // 여기에 API 응답 데이터를 저장합니다.

  @override
  void initState() {
    super.initState();
    loadSavingGoals(); // initState에서 데이터 로딩을 시작합니다.
  }

  Future<void> loadSavingGoals() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedSavingGoals = await fetchSavingGoalsFromAPI();
    var goalList = await getGoalList(3);
    setState(() {
      if (goalList != null) {
        mySavingGoals = goalList;
        // API로부터 받아온 데이터를 상태에 저장합니다.
      } else {
        mySavingGoals = fetchedSavingGoals;
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
      },
      {
        "goal_id": 2,
        "goal_name": "목표 2",
        "goal_amt": 800000,
        "status": 0,
        "start_date": "2024.03.07",
        "withdraw_date": "2024.05.18",
        "end_date": "2024.07.30",
        "percentage": 99.0,
        "saved_amt": 793507
      },
      {
        "goal_id": 3,
        "goal_name": "목표 3",
        "goal_amt": 1000000,
        "status": 0,
        "start_date": "2024.01.08",
        "withdraw_date": "2024.01.27",
        "end_date": "2024.11.05",
        "percentage": 1.0,
        "saved_amt": 12700
      },
      {
        "goal_id": 4,
        "goal_name": "목표 4",
        "goal_amt": 300000,
        "status": 1,
        "start_date": "2024.01.09",
        "withdraw_date": "2024.06.30",
        "end_date": "2024.10.07",
        "percentage": 100.0,
        "saved_amt": 300000
      },
      {
        "goal_id": 5,
        "goal_name": "목표 5",
        "goal_amt": 600000,
        "status": 1,
        "start_date": "2023.12.20",
        "withdraw_date": "2024.02.11",
        "end_date": "2024.07.07",
        "percentage": 100.0,
        "saved_amt": 600000
      },
      {
        "goal_id": 6,
        "goal_name": "목표 6",
        "goal_amt": 800000,
        "status": 1,
        "start_date": "2024.02.08",
        "withdraw_date": "2024.04.24",
        "end_date": "2024.12.15",
        "percentage": 100.0,
        "saved_amt": 800000
      },
      {
        "goal_id": 7,
        "goal_name": "목표 7",
        "goal_amt": 200000,
        "status": 1,
        "start_date": "2024.02.21",
        "withdraw_date": "2024.10.01",
        "end_date": "2024.11.23",
        "percentage": 100.0,
        "saved_amt": 200000
      },
      {
        "goal_id": 8,
        "goal_name": "목표 8",
        "goal_amt": 700000,
        "status": 2,
        "start_date": "2024.01.25",
        "withdraw_date": "2024.10.08",
        "end_date": "2024.09.11",
        "percentage": 25.0,
        "saved_amt": 176971
      },
      {
        "goal_id": 9,
        "goal_name": "목표 9",
        "goal_amt": 500000,
        "status": 2,
        "start_date": "2024.02.09",
        "withdraw_date": "2024.09.01",
        "end_date": "2024.08.21",
        "percentage": 99.0,
        "saved_amt": 497718
      },
      {
        "goal_id": 10,
        "goal_name": "목표 10",
        "goal_amt": 300000,
        "status": 2,
        "start_date": "2023.12.23",
        "withdraw_date": "2024.11.11",
        "end_date": "2024.10.14",
        "percentage": 26.0,
        "saved_amt": 78564
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 현재 진행중인 목표 (status가 0인 경우)
    List<dynamic> currentGoals =
        mySavingGoals.where((goal) => goal['status'] == 0).toList();

    // 완료된 목표 (status가 1 또는 2인 경우)
    List<dynamic> completedGoals = mySavingGoals
        .where((goal) => goal['status'] == 1 || goal['status'] == 2)
        .toList();

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

    List<Widget> completedGoalWidgets = completedGoals.map<Widget>((goal) {
      return SavingGoal(
        goalId: goal['goal_id'],
        goalName: goal['goal_name'],
        goalAmt: goal['goal_amt'],
        status: goal['status'],
        startDate: goal['start_date'],
        withdrawDate: goal['withdraw_date'],
        endDate: goal['end_date'],
        percentage: goal['percentage'],
        savedAmt: goal['saved_amt'],
      );
    }).toList();

    // 완료된 목표 없으면 추가 위젯 추가.
    if (completedGoals.isEmpty) {
      completedGoalWidgets.add(const SavingGoalPlus());
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('저축 목표'),
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Text(
                  '현재 목표',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '지난 목표',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 현재 진행중인 목표 탭
            ListView(
              children: [
                ...currentGoalWidgets,
                const SavingGoalPlus(),
              ],
            ),
            ListView(
              children: [
                ...completedGoalWidgets,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
