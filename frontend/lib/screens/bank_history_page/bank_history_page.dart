import 'package:flutter/material.dart';
import 'package:frontend/models/account_list_data.dart';
import 'package:frontend/models/dummy_data_account.dart';
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
            Container(
              width: double.infinity,
              color: Color(0xFFA0CAFD),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankData.account_num,
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    moneyFormat.format(bankData.balance_amt),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8)),
                        onPressed: () {},
                        child: const Text(
                          '이체',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(children: [
              SizedBox(width: 20),
              DropdownButtonHistory(),
              Spacer(),
            ]),
            for (int i = 0; i < dummyDataList.length; i++)
              Text(dummyDataList[i].trans_title)
          ],
        ),
      ),
    );
  }
}
