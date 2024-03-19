import 'package:flutter/material.dart';
import 'package:frontend/models/account_list_data.dart';
import 'package:frontend/screens/bank_history_page/bank_history_page.dart';
import 'package:intl/intl.dart';

class BankBook extends StatefulWidget {
  const BankBook({super.key, required this.bankData});

  final AccountListData bankData;
  @override
  State<BankBook> createState() => _BankBook();
}

class _BankBook extends State<BankBook> {
  var moneyFormat = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFC1C7CE)),
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFA0CAFD),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bankData.account_name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              widget.bankData.account_num,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Center(
              child: Text(
                moneyFormat.format(widget.bankData.balance_amt),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF264CB2)),
                  ),
                  onPressed: () {
                    toBankHistoryPage(context);
                  },
                  child: const Text(
                    '내역',
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF264CB2)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    '이체',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toBankHistoryPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BankHistoryPage(
                bankData: widget.bankData,
              )),
    );
  }
}
