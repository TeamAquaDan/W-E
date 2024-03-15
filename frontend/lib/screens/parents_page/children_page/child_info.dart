import 'package:flutter/material.dart';
import 'package:frontend/widgets/pin_money.dart';

class ChildInfo extends StatelessWidget {
  const ChildInfo({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PinMoney(
            PinMoneyDay: 16,
            PinMoneyMoney: 100000,
            childName: name,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('미션'),
                FilledButton(onPressed: () {}, child: Text('미션 추가'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
