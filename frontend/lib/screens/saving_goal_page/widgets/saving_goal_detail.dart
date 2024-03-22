import 'package:flutter/material.dart';
import 'package:frontend/api/save/goal_detail_api.dart';
import 'package:intl/intl.dart';

class SavingGoalDetail extends StatefulWidget {
  const SavingGoalDetail({super.key, required this.goalId});

  final int goalId;

  @override
  State<StatefulWidget> createState() => _SavingGoalDetailState();
}

class _SavingGoalDetailState extends State<SavingGoalDetail> {
  // late Map<dynamic, dynamic> goalDetails = {}; // 여기에 API 응답 데이터를 저장합니다.
  late Future<Map<dynamic, dynamic>> _goalDetailsFuture;
  @override
  void initState() {
    super.initState();
    _goalDetailsFuture = loadGoalDetail(); // initState에서 데이터 로딩을 시작합니다.
  }

  Future<Map<dynamic, dynamic>> loadGoalDetail() async {
    var fetchedGoalDetails = await getGoalDetail(widget.goalId);
    print('요청 $fetchedGoalDetails');
    return fetchedGoalDetails ??=
        fetchedGoalDetails = await fetchGoalDetailsFromAPI();
  }

  Future<Map> fetchGoalDetailsFromAPI() async {
    return {
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
    };
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('목표 상세'),
      ),
      body: FutureBuilder<Map<dynamic, dynamic>>(
        future: _goalDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(strokeWidth: 4)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final goalDetails = snapshot.data!;
            final int toSaveAmount = (goalDetails['goal_amt'] ?? 0) -
                (goalDetails['saved_amt'] ?? 0);
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${goalDetails["goal_name"]} 까지',
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
                      Text('${goalDetails['percentage']}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: goalDetails["percentage"] != null
                        ? goalDetails["percentage"] / 100
                        : 0.0,
                    backgroundColor: const Color.fromARGB(255, 135, 146, 150),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF46A1F5)),
                    minHeight: 5,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
