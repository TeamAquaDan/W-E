import 'package:flutter/material.dart';
import 'package:frontend/models/account_list_data.dart';
import 'package:frontend/models/dummy_data_account.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_history_card.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_history_table.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_top_container.dart';
import 'package:frontend/screens/bank_history_page/widgets/trans_type_button.dart';
import 'package:intl/intl.dart';

class BankHistoryPage extends StatelessWidget {
  const BankHistoryPage({super.key, required this.bankData});
  final AccountListData bankData;

  @override
  Widget build(BuildContext context) {
    var moneyFormat = NumberFormat('###,###,###,### 원');
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
            BankHistoryTable(),
          ],
        ),
      ),
    );
  }
}
