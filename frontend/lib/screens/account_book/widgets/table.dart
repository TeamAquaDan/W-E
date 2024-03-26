import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';

class AccountBookTable extends StatefulWidget {
  @override
  _AccountBookTableState createState() => _AccountBookTableState();
}

class _AccountBookTableState extends State<AccountBookTable> {
  Map<String, dynamic> responseData = {};

  void fetchData() async {
    try {
      var response = await getAccountBook(2024, 3);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Income Amount: ${responseData['data']['income_amt']}"),
                Text("Expense Amount: ${responseData['data']['expense_amt']}"),
                Text(
                    "Expense Amount: ${responseData['data']['account_book_list']}"),
                // You can iterate over account_book_list and display its items here
              ],
            ),
    );
  }
}
