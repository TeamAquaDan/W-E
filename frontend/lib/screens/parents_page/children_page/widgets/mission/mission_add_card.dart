import 'package:flutter/material.dart';
import 'package:frontend/api/mission/add_mission_api.dart';

class MissionAddCard extends StatefulWidget {
  final int groupId;

  MissionAddCard({required this.groupId});

  @override
  _MissionAddCardState createState() => _MissionAddCardState();
}

class _MissionAddCardState extends State<MissionAddCard> {
  late TextEditingController _missionNameController;
  late TextEditingController _missionRewardController;
  late TextEditingController _deadlineDateController;

  @override
  void initState() {
    super.initState();
    _missionNameController = TextEditingController();
    _missionRewardController = TextEditingController();
    _deadlineDateController = TextEditingController();
  }

  @override
  void dispose() {
    _missionNameController.dispose();
    _missionRewardController.dispose();
    _deadlineDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '새로운 미션 추가',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _missionNameController,
              decoration: InputDecoration(labelText: '미션 제목'),
            ),
            TextField(
              controller: _missionRewardController,
              decoration: InputDecoration(labelText: '보상금액'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _deadlineDateController,
              decoration: InputDecoration(labelText: '마감일 (yyyy-mm-dd)'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                _addMission();
              },
              child: Text('미션 추가'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMission() async {
    String missionName = _missionNameController.text;
    int missionReward = int.tryParse(_missionRewardController.text) ?? 0;
    String deadlineDate = _deadlineDateController.text;

    try {
      await addMission(
        groupId: widget.groupId,
        missionName: missionName,
        missionReward: missionReward,
        deadlineDate: deadlineDate,
      );

      // 미션 추가 후 작업을 수행하거나 상태를 갱신할 수 있습니다.

      // 입력 필드 초기화
      _missionNameController.clear();
      _missionRewardController.clear();
      _deadlineDateController.clear();
    } catch (error) {
      // 오류 처리
      print('Error adding mission: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('미션 추가 중 오류가 발생했습니다.')),
      );
    }
  }
}
