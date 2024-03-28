import 'package:flutter/material.dart';
import 'package:frontend/api/mission/mission_list_api.dart';
import 'package:frontend/models/mission/mission_model.dart';
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
          return Column(
            children: missions.map((mission) {
              return MissionCard(mission: mission, groupId: widget.groupId);
            }).toList(),
          );
        }
      },
    );
  }
}
