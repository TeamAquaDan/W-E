import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/widgets/chart2.dart';
import 'package:frontend/screens/account_book/widgets/expense_chart.dart';

class AccountBookChart extends StatefulWidget {
  @override
  _AccountBookChartState createState() => _AccountBookChartState();
}

class _AccountBookChartState extends State<AccountBookChart> {
  Map<String, dynamic> responseData = {};

  void fetchData() async {
    try {
      var response = await getAccountBookChart(2024, 3);
      setState(() {
        responseData = response;
      });
      debugPrint('데이터 통신 결과 $responseData');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: responseData.isEmpty
          ? CircularProgressIndicator()
          : Column(
              children: [PieChartSample2(data: responseData['data'])],
            ),
    );
  }
}
