import 'package:flutter/material.dart';
import 'package:frontend/models/mission/mission_model.dart';
import 'package:intl/intl.dart';

class ChildMissionCard extends StatefulWidget {
  final MissionModel mission;

  const ChildMissionCard({
    super.key,
    required this.mission,
  });

  @override
  State<ChildMissionCard> createState() => _ChildMissionCardState();
}

class _ChildMissionCardState extends State<ChildMissionCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.mission.missionId == -1) {
      return const SizedBox.shrink(); // missionId가 -1인 경우 아무것도 출력하지 않음
    }

    var moneyFormat = NumberFormat('###,###,###,### 원');
    Color cardColor = _getCardColor(widget.mission.status);
    Color textColor = _getTextColor(widget.mission.status);
    final DateTime now = DateTime.now();
    final DateTime deadline = DateTime.parse(widget.mission.deadlineDate);
    final int dDay = deadline.difference(now).inDays;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mission.missionName,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontFamily: 'Aggro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      moneyFormat.format(widget.mission.missionReward),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontFamily: 'Aggro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                widget.mission.status == 0
                    ? Text(
                        'D-$dDay',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'GangwonEduPower',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Column(
                        children: [
                          widget.mission.status == 1
                              ? const Icon(Icons.check)
                              : const Icon(Icons.close),
                          const Text(
                            '종료',
                            style: TextStyle(
                              color: Color(0xFF3c3c3c),
                              fontSize: 30,
                              fontFamily: 'Aggro',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ],
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
