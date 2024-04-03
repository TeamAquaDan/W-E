import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/widgets/nego/nego_detail_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NegoCard extends StatelessWidget {
  const NegoCard({super.key, required this.nego});
  final Map<String, dynamic> nego;

  @override
  Widget build(BuildContext context) {
    var moneyFormat = NumberFormat('###,###,###,### 원');
    Color cardColor = _getCardColor(nego['status']);
    Color textColor = _getTextColor(nego['status']);
    return InkWell(
      onTap: () {
        Get.to(NegoDetailPage(
          nego: nego,
        ));
      },
      child: Card(
        color: cardColor,
        // margin: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '새로운 용돈 인상 신청이 왔어요!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Aggro',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '요청 금액 : ${nego['nego_amt']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Aggro',
                  fontWeight: FontWeight.w400,
                ),
              ),
              // Text('요청 금액 : $nego')
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(int status) {
    switch (status) {
      case 0:
        return const Color(0xFF568EF8);
      case 1:
        return const Color(0xFFE8E8E8);
      case 2:
        return const Color(0xFFE8E8E8);
      default:
        return const Color(0xFF568EF8);
    }
  }

  Color _getTextColor(int status) {
    switch (status) {
      case 0:
        return Colors.white;
      case 1:
        return const Color(0xFF3c3c3c);
      case 2:
        return const Color(0xFF3c3c3c);
      default:
        return Colors.white;
    }
  }
}
