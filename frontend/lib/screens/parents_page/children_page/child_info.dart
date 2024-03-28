import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission/mission_add_card.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission/mission_list.dart';
import 'package:frontend/screens/parents_page/widgets/child_card.dart';
import 'package:frontend/widgets/pin_money.dart';

class ChildInfo extends StatelessWidget {
  const ChildInfo({super.key, required this.data});
  final Child data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ChildCard(
              groupId: data.groupId,
              userId: data.userId,
              groupNickname: data.groupNickname),
          //미션 추가
          MissionAddCard(groupId: data.groupId),
          MissionList(
            groupId: data.groupId,
          )
        ],
      ),
    );
  }
}
