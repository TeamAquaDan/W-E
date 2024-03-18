import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission_card.dart';
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
                const Text(
                  '미션',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // 미션 등록 35
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F62DE)),
                    child: const Text(
                      '미션 추가',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
          // 미션 목록 조회 37
          const MissionCard(
            title: '미션 내용',
            money: 1000,
            deadline: '24.04.05',
          ),
        ],
      ),
    );
  }
}
