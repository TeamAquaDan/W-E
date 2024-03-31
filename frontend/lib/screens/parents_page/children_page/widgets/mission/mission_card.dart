import 'package:flutter/material.dart';
import 'package:frontend/api/mission/add_mission_api.dart';
import 'package:frontend/models/mission/mission_model.dart';
import 'package:intl/intl.dart';

class MissionCard extends StatefulWidget {
  final MissionModel mission;
  final int groupId;
  final VoidCallback? onMissionStatusChanged;
  const MissionCard(
      {super.key,
      required this.mission,
      required this.groupId,
      this.onMissionStatusChanged});

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.mission.missionId == -1) {
      return const SizedBox.shrink(); // missionId가 -1인 경우 아무것도 출력하지 않음
    }

    var moneyFormat = NumberFormat('###,###,###,### 원');
    Color cardColor = _getCardColor(widget.mission.status);

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
                      widget.mission.missionName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.mission.deadlineDate,
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
                      moneyFormat.format(widget.mission.missionReward),
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
                          onPressed: () async {
                            await patchMission(
                                groupId: widget.groupId,
                                missionId: widget.mission.missionId,
                                status: 1);
                            widget.onMissionStatusChanged?.call();
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
                          onPressed: () async {
                            await patchMission(
                                groupId: widget.groupId,
                                missionId: widget.mission.missionId,
                                status: 2);
                            widget.onMissionStatusChanged?.call();
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
