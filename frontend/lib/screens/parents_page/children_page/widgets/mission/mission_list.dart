import 'package:flutter/material.dart';
import 'package:frontend/api/mission/mission_list_api.dart';
import 'package:frontend/models/mission/mission_model.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission/mission_add_card.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission/mission_card.dart';

class MissionList extends StatefulWidget {
  final int groupId;

  const MissionList({super.key, required this.groupId});

  @override
  _MissionListState createState() => _MissionListState();
}

class _MissionListState extends State<MissionList> {
  late Future<List<MissionModel>> _missionListFuture;

  @override
  void initState() {
    super.initState();
    _missionListFuture = getMissionList(widget.groupId);
  }

  @override
  void didUpdateWidget(MissionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.groupId != oldWidget.groupId) {
      setState(() {
        _missionListFuture = getMissionList(widget.groupId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MissionModel>>(
      future: _missionListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<MissionModel> missions = snapshot.data ?? [];
          missions.sort((a, b) {
            // status가 0인 것들을 위로 정렬하도록 비교 함수 작성
            if (a.status == 0 && b.status != 0) {
              return -1; // a가 0이고 b가 0이 아닌 경우 a를 먼저 위치하도록 함
            } else if (a.status != 0 && b.status == 0) {
              return 1; // b가 0이고 a가 0이 아닌 경우 b를 먼저 위치하도록 함
            } else {
              return 0; // 그 외의 경우에는 순서를 변경하지 않음
            }
          });
          return Column(
            children: [
              //미션 추가
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  children: [
                    const Text(
                      '미션 목록',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) => MissionAddCard(
                                    groupId: widget.groupId,
                                    onMissionStatusChanged: () {
                                      setState(() {
                                        _missionListFuture =
                                            getMissionList(widget.groupId);
                                      });
                                    },
                                  ),
                              isScrollControlled: true);
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
              Column(
                children: missions.map((mission) {
                  return MissionCard(
                    mission: mission,
                    groupId: widget.groupId,
                    onMissionStatusChanged: () {
                      setState(() {
                        _missionListFuture = getMissionList(widget.groupId);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
