import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingGoalDetail extends StatefulWidget {
  const SavingGoalDetail({super.key, required this.goalId});

  final int goalId;

  @override
  State<StatefulWidget> createState() => _SavingGoalDetailState();
}

class _SavingGoalDetailState extends State<SavingGoalDetail> {
  late List<dynamic> goalDetails = []; // 여기에 API 응답 데이터를 저장합니다.

  @override
  void initState() {
    super.initState();
    loadGoalDetail(); // initState에서 데이터 로딩을 시작합니다.
  }

  Future<void> loadGoalDetail() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedGoalDetails = await fetchGoalDetailsFromAPI();
    setState(() {
      goalDetails = fetchedGoalDetails; // API로부터 받아온 데이터를 상태에 저장합니다.
    });
  }

  Future<List<dynamic>> fetchGoalDetailsFromAPI() async {
    return [
      {
        "goal_id": 1,
        "goal_name": "여행 기금",
        "goal_amt": 5000000,
        "status": 0,
        "start_date": "2024.01.01",
        "withdraw_date": "2024.06.01",
        "end_date": "2024.12.31",
        "percentage": 40,
        "saved_amt": 2000000,
        "category": "여행"
      },
    ];
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    final int toSaveAmount =
        goalDetails[0]['goal_amt'] - goalDetails[0]['saved_amt'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('목표 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${goalDetails[0]["goal_name"]} 까지',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${formatNumber(toSaveAmount)}원',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${goalDetails[0]['percentage']}%',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: goalDetails[0]["percentage"] / 100, // 70% 진행
              backgroundColor: const Color.fromARGB(255, 135, 146, 150),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF46A1F5)),
              minHeight: 5,
            ),
          ],
        ),
      ),
    );
  }
}
