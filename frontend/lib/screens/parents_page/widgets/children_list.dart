import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:frontend/screens/parents_page/widgets/child_card.dart';
import 'package:frontend/screens/parents_page/widgets/nego/nego_list_widget.dart';

class ChildrenList extends StatefulWidget {
  const ChildrenList({super.key});

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  List<Child> children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    List<Child> loadedChildren = await getChildren();
    setState(() {
      children = loadedChildren;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: 700,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(), // ListView 스크롤 제거
        shrinkWrap: true, // ListView가 자신의 공간만 차지하도록 설정
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          Child child = children[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChildCard(
                  groupId: child.groupId,
                  userId: child.userId,
                  groupNickname: child.groupNickname),
              NegoListWidget(groupId: child.groupId)
            ],
          );
        },
      ),
    );
  }
}
