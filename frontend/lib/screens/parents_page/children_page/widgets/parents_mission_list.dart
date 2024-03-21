import 'package:flutter/material.dart';
import 'package:frontend/models/mission_data.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/add_mission_sheet.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission_card.dart';

class ParentsMissionList extends StatefulWidget {
  const ParentsMissionList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ParentsMissionList();
  }
}

class _ParentsMissionList extends State<ParentsMissionList> {
  final List<MissionData> _registeredMissions = [
    MissionData(
      mission_id: 1,
      status: 0,
      deadline_date: '24-05-05',
      mission_name: '어린이날 까지 차카게 살기',
      mission_reward: 10000,
      user_name: '김아들',
    ),
    MissionData(
      mission_id: 2,
      status: 0,
      deadline_date: '24-04-01',
      mission_name: '4월 까지 차카게 살기',
      mission_reward: 10000,
      user_name: '김아들',
    ),
    MissionData(
      mission_id: 3,
      status: 0,
      deadline_date: '24-06-03',
      mission_name: '무사고 100일',
      mission_reward: 10000,
      user_name: '김아들',
    ),
    MissionData(
      mission_id: 3,
      status: 0,
      deadline_date: '24-06-03',
      mission_name: '무사고 100일',
      mission_reward: 10000,
      user_name: '김아들',
    ),
    MissionData(
      mission_id: 3,
      status: 0,
      deadline_date: '24-06-03',
      mission_name: '무사고 100일',
      mission_reward: 10000,
      user_name: '김아들',
    ),
    MissionData(
      mission_id: 3,
      status: 0,
      deadline_date: '24-06-03',
      mission_name: '무사고 100일',
      mission_reward: 10000,
      user_name: '김아들',
    ),
  ];

  void _openAddMissionOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddMissionSheet(onAddMission: _addMission));
  }

  void _addMission(MissionData missionData) {
    setState(() {
      _registeredMissions.add(missionData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                    onPressed: _openAddMissionOverlay,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F62DE)),
                    child: const Text(
                      '미션 추가',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),

          // 미션 목록 조회 37
          for (int i = 0; i < _registeredMissions.length; i++)
            MissionCard(_registeredMissions[i])
        ],
      ),
    );
  }
}
