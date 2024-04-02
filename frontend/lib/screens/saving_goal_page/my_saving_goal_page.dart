import 'package:flutter/material.dart';
import 'package:frontend/api/save/goal_list_api.dart';
import 'package:frontend/models/store/saving_goal/goal_list_controller.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_detail.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_none_noadd.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_plus.dart';
import 'package:frontend/widgets/custom_tab_bar.dart';
import 'package:get/get.dart';

class MySavingGoalPage extends StatefulWidget {
  const MySavingGoalPage({super.key});

  @override
  State<MySavingGoalPage> createState() => _MySavingGoalPageState();
}

class _MySavingGoalPageState extends State<MySavingGoalPage> {
  late List<Map<String, dynamic>> mySavingGoals = []; // 여기에 API 응답 데이터를 저장합니다.
  bool isLoading = true;
  final GoalListController goalListController = Get.put(GoalListController());
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSavingGoals(); // initState에서 데이터 로딩을 시작합니다.
  }

  void onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  Future<void> loadSavingGoals() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedSavingGoals = await fetchSavingGoalsFromAPI();
    var goalList = await getGoalList(3);
    setState(() {
      if (goalList != null) {
        mySavingGoals = goalList;
        isLoading = false;
        // API로부터 받아온 데이터를 상태에 저장합니다.
      } else {
        mySavingGoals = fetchedSavingGoals;
      }
    });
  }

  void reloadGoals() {
    loadSavingGoals();
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
      completedGoalWidgets.add(SavingGoalPlus(onAddGoal: reloadGoals));
    }

    // 로딩 중이라면 로딩 인디케이터를 표시
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // 로딩 인디케이터
        ),
      );
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('저축 목표'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomTabBar(
              selectedTabIndex: selectedTabIndex,
              onTabChanged: onTabChanged,
              tabLabels: ['현재 목표', '지난 목표'],
            ),
          ),
        ),
        body: selectedTabIndex == 0
            ?
            // 현재 진행중인 목표 탭
            ListView(
                children: [
                  ...currentGoalWidgets,
                  SavingGoalPlus(
                    onAddGoal: reloadGoals,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            : ListView(
                children: [
                  ...completedGoalWidgets,
                ],
              ),
      ),
    );
  }
}
