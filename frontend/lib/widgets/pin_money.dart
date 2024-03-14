import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class PinMoney extends StatefulWidget {
  const PinMoney({
    super.key,
    required this.PinMoneyDay,
    required this.PinMoneyMoney,
    required this.childName,
  });
  final int PinMoneyDay;
  final int PinMoneyMoney;
  final String childName;
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.childName} 용돈',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateFormat.format(widget.PinMoneyDay),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  moneyFormat.format(widget.PinMoneyMoney),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '수정하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
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
