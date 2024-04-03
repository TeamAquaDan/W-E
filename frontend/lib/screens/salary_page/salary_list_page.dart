import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/salary_page/widgets/salary.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:intl/intl.dart';

class SalaryListPage extends StatefulWidget {
  const SalaryListPage({super.key});

  @override
  State<SalaryListPage> createState() => _SalaryListPageState();
}

class _SalaryListPageState extends State<SalaryListPage> {
  late List<dynamic> salaryList = []; // 여기에 API 응답 데이터를 저장합니다.

  @override
  void initState() {
    super.initState();
    loadSalarys(); // initState에서 데이터 로딩을 시작합니다.
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  Future<void> loadSalarys() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedSalarys = await fetchSalarysFromAPI();
    setState(() {
      salaryList = fetchedSalarys; // API로부터 받아온 데이터를 상태에 저장합니다.
    });
  }

  Future<List<dynamic>> fetchSalarysFromAPI() async {
    final DioService dioService = DioService();

    try {
      var response = await dioService.dio.get(
        '${baseURL}api/allowance/list',
      );
      print(response.data);
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void showSalaryDetailBottomSheet(BuildContext context, int groupId,
      String groupNickname, String userName) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<dynamic>>(
              future: fetchSalaryDetailsFromAPI(groupId), // API 요청 함수
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // 로딩 중 표시
                } else if (snapshot.hasError) {
                  return const Text('데이터를 불러오는 데 실패했습니다.');
                } else {
                  // 데이터가 성공적으로 불러와진 경우
                  var salaryDetails = snapshot.data ?? [];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' $groupNickname($userName)에게 요청한 내역',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: salaryDetails.length,
                            itemBuilder: (context, index) {
                              var detail = salaryDetails[index];
                              // 각 항목을 구성하는 위젯 반환
                              return Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff999999),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '요청 일시: ${detail['create_dtm']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '기존 용돈: ${formatNumber(detail['allowance_amt'])}원',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          detail['status'] == 0
                                              ? const Text(
                                                  ' (요청중)',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : detail['status'] == 1
                                                  ? const Text(
                                                      ' (승인됨)',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : const Text(
                                                      ' (거절됨)',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '요청 금액: ${formatNumber(detail['nego_amt'])}원',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '사유 : ${detail['comment']}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<List<dynamic>> fetchSalaryDetailsFromAPI(int groupId) async {
    // 여기에 API 요청을 수행하는 코드 작성
    // 가정된 함수이며 실제 API 경로와 요청 로직에 맞게 수정 필요
    try {
      print(groupId);
      print(groupId.runtimeType); // int 타입인지 확인 (int 타입이어야 함
      final DioService dioService = DioService();
      var response = await dioService.dio.get('${baseURL}api/nego/${groupId}');
      if (response.statusCode == 200) {
        print(response);
        return response.data['data']; // 예시 응답 구조
      } else {
        print('ErrorCode: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('용돈 목록'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadSalarys();
        },
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              // 스크롤 가능한 리스트를 위해 Expanded 위젯 사용
              child: ListView.builder(
                itemCount: salaryList.length, // 리스트의 항목 수
                itemBuilder: (context, index) {
                  final salary = salaryList[index];
                  return GestureDetector(
                    onTap: () => showSalaryDetailBottomSheet(
                      context,
                      salary['group_id'],
                      salary['group_nickname'] ?? salary['user_name'],
                      salary['user_name'],
                    ),
                    child: Salary(
                      isMonthly: salary['is_monthly'],
                      allowanceAmt: salary['allowance_amt'],
                      paymentDate: salary['payment_date'],
                      groupNickname:
                          salary['group_nickname'] ?? salary['user_name'],
                      groupId: salary['group_id'],
                      userId: salary['user_id'],
                      userName: salary['user_name'],
                      loadSalarysCallback: loadSalarys,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}