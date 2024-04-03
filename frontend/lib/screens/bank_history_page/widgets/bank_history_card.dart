import 'package:flutter/material.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:intl/intl.dart';

class BankHistoryCard extends StatelessWidget {
  BankHistoryCard({super.key, required this.data});
  final AccountHistoryData data;
  var moneyFormat = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      surfaceTintColor: Colors.white,
      elevation: 0,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  data.trans_dtm,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                Text(
                  data.trans_memo,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  moneyFormat.format(data.trans_amt),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: data.trans_type == 2 ? Colors.red : Colors.green),
                )
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Text(
                  moneyFormat.format(data.balance_amt),
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
