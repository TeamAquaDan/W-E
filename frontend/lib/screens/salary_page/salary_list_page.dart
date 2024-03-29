import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/salary_page/widgets/salary.dart';
import 'package:frontend/services/dio_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('용돈 내역'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 17, 17, 17),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '이번 달 용돈 : 50000원',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            // 스크롤 가능한 리스트를 위해 Expanded 위젯 사용
            child: ListView.builder(
              itemCount: salaryList.length, // 리스트의 항목 수
              itemBuilder: (context, index) {
                final salary = salaryList[index];
                return Salary(
                  isMonthly: salary['is_monthly'],
                  allowanceAmt: salary['allowance_amt'],
                  paymentDate: salary['payment_date'],
                  groupNickname: salary['group_nickname'] == null
                      ? salary['user_name']
                      : salary['group_nickname'],
                  groupId: salary['group_id'],
                  userId: salary['user_id'],
                  userName: salary['user_name'],
                  loadSalarysCallback: loadSalarys,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
