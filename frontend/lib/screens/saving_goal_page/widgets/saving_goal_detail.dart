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
      "start_date": "2024-01-01",
      "withdraw_date": "2024-06-01",
      "goal_date": "2024-12-31",
      "percentage": 40,
      "saved_amt": 2000000,
      "category": "여행"
    };
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  int calculateDDay(String endDateStr) {
    DateTime endDate = DateFormat('yyyy-MM-dd').parse(endDateStr);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); // 시간 무시

    int dDay = endDate.difference(today).inDays;
    return dDay; // 종료일 - 오늘의 날짜 차이를 일수로 반환
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
            return const Center(
              child: SizedBox(
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
                  const SizedBox(height: 50),
                  goalDetails['status'] != 100
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: const Color(0xffD7D7D7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ), // 배경 색상
                              ),
                              child: const Text(
                                '포기하기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: const Color(0xffD7D7D7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ), // 배경 색상
                              ),
                              child: const Text(
                                '저금하기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: const Color(0xff31B675),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ), // 배경 색상
                              ),
                              child: const Text(
                                '출금하기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 80),
                  const Text(
                    '목표 날짜',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'D-${calculateDDay(goalDetails['goal_date'])}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    '현재 금액',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    '${formatNumber(goalDetails['saved_amt'])} 원',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    '목표 금액',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    '${formatNumber(goalDetails['goal_amt'])} 원',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
