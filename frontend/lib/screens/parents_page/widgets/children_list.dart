import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:frontend/screens/parents_page/widgets/child_card.dart';

class ChildrenList extends StatefulWidget {
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(), // ListView 스크롤 제거
        shrinkWrap: true, // ListView가 자신의 공간만 차지하도록 설정
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          Child child = children[index];
          return ChildCard(
              groupId: child.groupId,
              userId: child.userId,
              groupNickname: child.groupNickname);
        },
      ),
    );
  }
}
