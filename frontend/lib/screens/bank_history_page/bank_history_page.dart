import 'package:flutter/material.dart';
import 'package:frontend/models/account_list_data.dart';
import 'package:frontend/widgets/bank_book.dart';

class BankHistoryPage extends StatelessWidget {
  const BankHistoryPage({super.key, required this.bankData});
  final AccountListData bankData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bankData.account_name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BankBook(
              bankData: bankData,
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
