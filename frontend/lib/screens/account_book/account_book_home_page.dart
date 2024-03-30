import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:frontend/screens/account_book/widgets/chart.dart';
import 'package:frontend/screens/account_book/widgets/table.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AccountBookHomePage extends StatefulWidget {
  const AccountBookHomePage({super.key});

  @override
  State<AccountBookHomePage> createState() => _AccountBookHomePageState();
}

class _AccountBookHomePageState extends State<AccountBookHomePage> {
  Map<String, dynamic> responseChartData = {};
  Map<String, dynamic> responseData = {};
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  @override
  void initState() {
    super.initState();
    fetchData(year, month);
  }

  void fetchData(int year, int month) async {
    try {
      var response = await getAccountBookChart(year, month);
      var response2 = await getAccountBook(year, month);
      setState(() {
        responseChartData = response;
        responseData = response2;
      });
      debugPrint('데이터 통신 결과 $responseChartData');
      debugPrint('데이터 통신 결과 $responseData');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void refreshData() {
    fetchData(year, month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('가계부'),
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
            Row(
              children: [
                const Spacer(),
                Text('$year년 $month월'),
                IconButton(
                  onPressed: () {
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
                  icon: const Icon(Icons.calendar_today), // 아이콘 변경
                ),
              ],
            ),
            AccountBookChart(data: responseChartData),
            SizedBox(height: 8),
            AccountBookTable(
              data: responseData,
              setData: refreshData,
            ),
          ],
        ),
      ),
    );
  }
}
