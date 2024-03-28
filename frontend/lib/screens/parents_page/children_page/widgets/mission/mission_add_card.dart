import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api/mission/add_mission_api.dart';
import 'package:frontend/screens/parents_page/children_page/child_management_page.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

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
  late DateTime _deadlineDate;

  @override
  void initState() {
    super.initState();
    _missionNameController = TextEditingController();
    _missionRewardController = TextEditingController();
    _deadlineDateController = TextEditingController();
    _deadlineDate = DateTime.now();
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
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '새로운 미션 추가',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              // TextField(
              //   controller: _deadlineDateController,
              //   decoration: InputDecoration(labelText: '마감일 (yyyy-mm-dd)'),
              // ),
              Row(
                children: [
                  Text(
                    DateFormat('yyyy-MM-dd').format(_deadlineDate),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text('마감일 선택'),
                  ),
                ],
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
      Get.to(() => ChildManagementPage());
    } catch (error) {
      // 오류 처리
      print('Error adding mission: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('미션 추가 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101), // 임의의 미래 날짜
    );
    if (pickedDate != null && pickedDate != _deadlineDate) {
      setState(() {
        _deadlineDate = pickedDate;
        _deadlineDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }
}
