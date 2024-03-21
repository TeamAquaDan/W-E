import 'package:flutter/material.dart';
import 'package:frontend/screens/salary_page/widgets/salary.dart';

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
    return [
      {
        "is_monthly": true,
        "allowance_amt": 50000,
        "payment_date": 15,
        "group_nickname": "가족 그룹 A",
        "group_id": 1,
        "user_id": 101,
        "user_name": "김철수"
      },
      {
        "is_monthly": false,
        "allowance_amt": 30000,
        "payment_date": 2,
        "group_nickname": "가족 그룹 B",
        "group_id": 2,
        "user_id": 102,
        "user_name": "박영희"
      },
      {
        "is_monthly": true,
        "allowance_amt": 100000,
        "payment_date": 5,
        "group_nickname": "가족 그룹 C",
        "group_id": 3,
        "user_id": 103,
        "user_name": "이민준"
      },
      {
        "is_monthly": true,
        "allowance_amt": 75000,
        "payment_date": 10,
        "group_nickname": "가족 그룹 D",
        "group_id": 4,
        "user_id": 104,
        "user_name": "최수지"
      },
      {
        "is_monthly": false,
        "allowance_amt": 60000,
        "payment_date": 7,
        "group_nickname": "가족 그룹 E",
        "group_id": 5,
        "user_id": 105,
        "user_name": "정하늘"
      },
      {
        "is_monthly": true,
        "allowance_amt": 45000,
        "payment_date": 12,
        "group_nickname": "가족 그룹 F",
        "group_id": 6,
        "user_id": 106,
        "user_name": "한지민"
      },
      {
        "is_monthly": true,
        "allowance_amt": 55000,
        "payment_date": 18,
        "group_nickname": "가족 그룹 G",
        "group_id": 7,
        "user_id": 107,
        "user_name": "송다은"
      },
      {
        "is_monthly": true,
        "allowance_amt": 85000,
        "payment_date": 28,
        "group_nickname": "가족 그룹 H",
        "group_id": 8,
        "user_id": 108,
        "user_name": "우성호"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  groupNickname: salary['group_nickname'],
                  groupId: salary['group_id'],
                  userId: salary['user_id'],
                  userName: salary['user_name'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
