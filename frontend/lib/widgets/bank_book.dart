import 'package:flutter/material.dart';

class BankBook extends StatefulWidget {
  const BankBook({super.key, required this.title});
  final String title;

  @override
  State<BankBook> createState() => _BankBook();
}

class _BankBook extends State<BankBook> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFC1C7CE)),
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFA0CAFD),
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
            const Text(
              '1234-123-12345',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const Center(
              child: Text(
                '3,145,000원',
                style: TextStyle(
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
                        MaterialStateProperty.all<Color>(Color(0xFF264CB2)),
                  ),
                  onPressed: () {},
                  child: Text(
                    '내역',
                  ),
                ),
                SizedBox(width: 12),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF264CB2)),
                  ),
                  onPressed: () {},
                  child: Text(
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
