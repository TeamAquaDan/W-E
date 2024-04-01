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
    Color textColor = _getTextColor(widget.mission.status);
    final DateTime now = DateTime.now();
    final DateTime deadline = DateTime.parse(widget.mission.deadlineDate);
    final int dDay = deadline.difference(now).inDays;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // 테두리 반경 설정
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '미션을 성공했나요?',
                        style: TextStyle(
                          color: Color(0xFF54595E),
                          fontSize: 24.95,
                          fontFamily: 'SB Aggro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await patchMission(
                                    groupId: widget.groupId,
                                    missionId: widget.mission.missionId,
                                    status: 2);
                                widget.onMissionStatusChanged?.call();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 153, 153, 153),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                              ),
                              child: const Text(
                                '실패',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'SB Aggro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await patchMission(
                                    groupId: widget.groupId,
                                    missionId: widget.mission.missionId,
                                    status: 1);
                                widget.onMissionStatusChanged?.call();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF568EF8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                              ),
                              child: const Text(
                                '성공',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'SB Aggro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // actions: <Widget>[
              //   TextButton(
              //     child: Text('Close'),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //   ),
              // ],
            );
          },
        );
      },
      child: Card(
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
                          fontFamily: 'SB Aggro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        moneyFormat.format(widget.mission.missionReward),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 30,
                          fontFamily: 'SB Aggro',
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
                                color: Color(0xFF919191),
                                fontSize: 30,
                                fontFamily: 'SB Aggro',
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
        return const Color(0xFF919191);
      case 2:
        return const Color(0xFF919191);
      default:
        return Colors.white;
    }
  }
}
