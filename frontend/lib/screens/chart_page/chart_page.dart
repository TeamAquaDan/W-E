import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/account_book_home_page.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:frontend/screens/chart_page/widgets/chart.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Map<String, dynamic> responseChartData = {};
  Map<String, dynamic> responseData = {};
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  final formatter = NumberFormat('###,###,###,### 원');
  bool _isLoading = true;
  int tabState = 0;
  List<dynamic>? filteredData;

  @override
  void initState() {
    super.initState();
    fetchData(year, month);
  }

  void fetchData(int year, int month) async {
    try {
      var response = await getAccountBookChart(year, month);
      // var response2 = await getAccountBook(year, month);

      if (response != null && response['data'] != null) {
        var incomeAmt = response['data']['income_amt'];
        // 여기에 incomeAmt를 처리하는 코드를 추가하세요.
      }

      setState(() {
        responseChartData = response;
        // responseData = response2;
      });
      // debugPrint('데이터 통신 결과 $responseChartData');
      // debugPrint('데이터 통신 결과 $responseData');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void refreshData() {
    fetchData(year, month);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Scaffold(
            appBar: AppBar(
              // automaticallyImplyLeading: false,
              title: Row(
                children: [
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const AccountBookHomePage());
                      },
                      child: const Text(
                        '가계부',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                        ),
                      )),
                  const Spacer(),
                  const Text('통계'),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Get.to(() => FormAccountBook(
                              setData: refreshData,
                            ));
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AccountBookChart(data: responseChartData),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
  }
}
