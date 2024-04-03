import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/api/save/goal_detail_api.dart';
import 'package:frontend/screens/saving_goal_page/my_saving_goal_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
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

  void showDepositDialog(int goalId, String goalName) async {
    TextEditingController amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 바텀 시트를 전체 화면으로 확장 가능하게 설정
      builder: (BuildContext context) {
        // 바텀 시트의 최소 높이를 확보하기 위해 Padding 위젯 사용
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // 키보드 높이에 맞춰서 패딩 적용
          child: SingleChildScrollView(
            // 스크롤 가능한 바텀 시트 내용
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    '저축하기',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff424347),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '목표 이름',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    goalName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff3e3e3e)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '저축할 금액',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff3e3e3e),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isEmpty) {
                          return newValue.copyWith(text: '');
                        } else if (newValue.text.compareTo(oldValue.text) !=
                            0) {
                          final int value =
                              int.parse(newValue.text.replaceAll(',', ''));
                          final String newText =
                              NumberFormat('#,###').format(value);
                          return newValue.copyWith(
                              text: newText,
                              selection: TextSelection.collapsed(
                                  offset: newText.length));
                        }
                        return newValue;
                      })
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: const Text(
                            '저축하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xff568EF8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            final DioService dioService = DioService();
                            dioService.dio.patch(
                              '${baseURL}api/goal/save',
                              data: {
                                'goal_id': goalId,
                                'save_amt': int.parse(
                                    amountController.text.replaceAll(',', '')),
                              },
                            ).then((response) {
                              print('전송 성공! $response');
                              Navigator.of(context).pop(); // 바텀 시트 닫기
                              setState(() {
                                _goalDetailsFuture =
                                    loadGoalDetail(); // 목표 상세 다시 불러오기
                              });
                            }).catchError((error) {
                              print(error);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> _categoryImoge = {
      "001": "🎁",
      "002": "📱",
      "003": "📎",
      "004": "👕",
      "005": "🎮",
      "006": "🏠",
      "007": "🍔",
      "008": "📚",
      "009": "💍",
      "010": "💄",
      "000": "🐳"
    };
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('저축 목표'),
        centerTitle: true,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                        ],
                      ),
                      Text(
                        _categoryImoge[goalDetails['category']],
                        style: const TextStyle(
                          fontSize: 45,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${goalDetails['percentage'].toStringAsFixed(2)}%',
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
                  goalDetails['percentage'] != 100
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          Center(child: const Text('포기하실건가요?')),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 30,
                                                  vertical: 10,
                                                ),
                                                backgroundColor:
                                                    Color(0xff777777),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () {
                                                final DioService dioService =
                                                    DioService();
                                                dioService.dio.patch(
                                                    '${baseURL}api/goal',
                                                    data: {
                                                      'goal_id': goalDetails[
                                                          'goal_id'],
                                                      'status': 2,
                                                    }).then((res) {
                                                  print('포기 성공! $res');
                                                  Get.to(() =>
                                                      const MySavingGoalPage());
                                                }).catchError((err) {});
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                '포기',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 30,
                                                  vertical: 10,
                                                ),
                                                backgroundColor:
                                                    Color(0xff568ef8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                '아뇨',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
                              onPressed: () {
                                showDepositDialog(goalDetails['goal_id'],
                                    goalDetails['goal_name']);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: const Color(0xff568EF8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ), // 배경 색상
                              ),
                              child: const Text(
                                '저금하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('출금하기'),
                                      content: const Text('출금 하시겠습니까?'),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 30,
                                                  vertical: 10,
                                                ),
                                                backgroundColor:
                                                    Color(0xff777777),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                '취소',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 30,
                                                  vertical: 10,
                                                ),
                                                backgroundColor:
                                                    Color(0xff568ef8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () async {
                                                final DioService dioService =
                                                    DioService();
                                                try {
                                                  var response =
                                                      await dioService.dio.patch(
                                                          '${baseURL}api/goal',
                                                          data: {
                                                        'goal_id': goalDetails[
                                                            'goal_id'],
                                                        'status': 1,
                                                      });
                                                  print(
                                                      '출금성공 $response'); // '출금 성공!
                                                } catch (e) {
                                                  print(e);
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                '출금',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: const Color(0xff568EF8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ), // 배경 색상
                              ),
                              child: const Text(
                                '출금하기',
                                style: TextStyle(
                                  color: Colors.white,
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
