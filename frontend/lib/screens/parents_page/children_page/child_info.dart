import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission/mission_add_card.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/mission/mission_list.dart';
import 'package:frontend/screens/parents_page/widgets/child_card.dart';

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
                          builder: (BuildContext context) =>
                              MissionAddCard(groupId: data.groupId),
                          isScrollControlled: true);
                    },
                    icon: const Icon(Icons.add)),
              ],
            ),
          ),
          // MissionAddCard(groupId: data.groupId),
          MissionList(
            groupId: data.groupId,
          )
        ],
      ),
    );
  }
}
