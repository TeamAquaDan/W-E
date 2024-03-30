import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:frontend/screens/account_book/widgets/chart.dart';
import 'package:frontend/screens/account_book/widgets/table.dart';
import 'package:get/get.dart';

class AccountBookHomePage extends StatefulWidget {
  const AccountBookHomePage({super.key});

  @override
  State<AccountBookHomePage> createState() => _AccountBookHomePageState();
}

class _AccountBookHomePageState extends State<AccountBookHomePage> {
  Map<String, dynamic> responseChartData = {};
  Map<String, dynamic> responseData = {};
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      var response = await getAccountBookChart(2024, 3);
      var response2 = await getAccountBook(2024, 3);
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
    fetchData();
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
