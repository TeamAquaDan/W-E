import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/account_book_home_page.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:frontend/screens/chart_page/widgets/chart.dart';
import 'package:frontend/widgets/custom_tab_bar.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
  int selectedTabIndex = 1;
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

  void onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: const Color(0xFF568EF8),
                child: InkWell(
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 1, 1),
                      lastDate: DateTime(DateTime.now().year + 1, 12),
                      initialDate: DateTime.now(),
                    ).then((date) {
                      if (date != null) {
                        year = date.year;
                        month = date.month;
                        refreshData(); // 데이터 갱신
                      }
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$year년 $month월',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 32),
                        const Icon(
                          Icons.calendar_month,
                          size: 38.0,
                          color: Colors.white,
                        )
                        // Container(
                        //   width: 1.5, // 원하는 너비로 설정
                        //   height: 37,
                        //   color: Colors.white,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              AccountBookChart(data: responseChartData),
              const SizedBox(height: 8),
            ],
          );
  }
}
