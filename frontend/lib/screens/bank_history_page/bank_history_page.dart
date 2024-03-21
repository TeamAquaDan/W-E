import 'package:flutter/material.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_history_table.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_top_container.dart';

class BankHistoryPage extends StatelessWidget {
  const BankHistoryPage({super.key, required this.bankData});
  final AccountListData bankData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA0CAFD),
        title: Text(
          bankData.account_name,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BankTopContainer(bankData: bankData),
            BankHistoryTable(account_id: bankData.account_id),
          ],
        ),
      ),
    );
  }
}
