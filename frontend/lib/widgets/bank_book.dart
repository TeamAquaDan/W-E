import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankBook extends StatefulWidget {
  const BankBook(
      {super.key,
      required this.title,
      required this.bankBookNum,
      required this.bankBookMoney});
  final String title;
  final String bankBookNum;
  final int bankBookMoney;
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
              widget.title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              widget.bankBookNum,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Center(
              child: Text(
                moneyFormat.format(widget.bankBookMoney),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(const Color(0xFF264CB2)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    '내역',
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(const Color(0xFF264CB2)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    '이체',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
