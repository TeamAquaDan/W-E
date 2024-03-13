import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PinMoney extends StatefulWidget {
  const PinMoney(
      {super.key, required this.PinMoneyDay, required this.PinMoneyMoney});
  final int PinMoneyDay;
  final int PinMoneyMoney;
  @override
  State<PinMoney> createState() => _PinMoney();
}

class _PinMoney extends State<PinMoney> {
  var dateFormat = NumberFormat('매달 ##일');
  var moneyFormat = NumberFormat('###,###,###,### 원');
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFC1C7CE)),
        borderRadius: BorderRadius.circular(20),
      ),
      color: const Color(0xFF7A97FF),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dateFormat.format(widget.PinMoneyDay),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '수정하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  moneyFormat.format(widget.PinMoneyMoney),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF3F62DE)),
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
