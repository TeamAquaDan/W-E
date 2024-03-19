import 'package:flutter/material.dart';
import 'package:frontend/widgets/bank_book.dart';

class BankHistoryPage extends StatelessWidget {
  const BankHistoryPage({
    super.key,
    required this.title,
    // required this.bankBookNum,
    // required this.bankBookMoney,
  });
  final String title;
  // final String bankBookNum;
  // final int bankBookMoney;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BankBook(
              title: '통장 이름1',
              bankBookNum: '111-1234-12345',
              bankBookMoney: 112000,
            ),
            Row(
              children: [Text('내역')],
            )
          ],
        ),
      ),
    );
  }
}
