import 'package:flutter/material.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/screens/transfer_page/transfer_page.dart';
import 'package:intl/intl.dart';

class BankTopContainer extends StatelessWidget {
  const BankTopContainer({super.key, required this.bankData});
  final AccountListData bankData;
  @override
  Widget build(BuildContext context) {
    var moneyFormat = NumberFormat('###,###,###,### 원');
    return Container(
      width: double.infinity,
      color: const Color(0xFFA0CAFD),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankData.account_num,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            moneyFormat.format(bankData.balance_amt),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
                onPressed: () {
                  toTransferPage(context);
                },
                child: const Text(
                  '이체',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void toTransferPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TransferPage(
                bankData: bankData,
              )),
    );
  }
}
