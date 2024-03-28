import 'package:flutter/material.dart';
import 'package:frontend/api/mission/add_mission_api.dart';
import 'package:frontend/models/mission/mission_model.dart';
import 'package:intl/intl.dart';

class MissionCard extends StatelessWidget {
  final MissionModel mission;
  final int groupId;
  const MissionCard({super.key, required this.mission, required this.groupId});

  @override
  Widget build(BuildContext context) {
    var moneyFormat = NumberFormat('###,###,###,### 원');
    Color cardColor = _getCardColor(mission.status);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mission.missionName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      mission.deadlineDate,
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      moneyFormat.format(mission.missionReward),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // 미션 관리 36
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            patchMission(
                                groupId: groupId,
                                missionId: mission.missionId,
                                status: 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 131, 220, 183),
                          ),
                          child: const Text(
                            '성공',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            patchMission(
                                groupId: groupId,
                                missionId: mission.missionId,
                                status: 2);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 220, 131, 131),
                          ),
                          child: const Text(
                            '실패',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
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
        return const Color(0xFF7A97FF);
      case 1:
        return const Color(0xFF83DCB7);
      case 2:
        return const Color(0xFFDC8787);
      default:
        return const Color(0xFF7A97FF);
    }
  }
}
