import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/api/allowance/children_api.dart';
import 'package:frontend/screens/parents_page/children_page/child_info.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/child_tab.dart';

class ChildManagementPage extends StatefulWidget {
  const ChildManagementPage({super.key});

  @override
  State<ChildManagementPage> createState() => _ChildManagementPage();
}

class _ChildManagementPage extends State<ChildManagementPage> {
  int _selectedIndex = 0;
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
    return DefaultTabController(
      length: children.length, // 자녀 수만큼 탭의 길이 설정
      initialIndex: _selectedIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내 자녀 조회'),
          bottom: TabBar(
            // indicatorSize: TabBarIndicatorSize.label,
            tabs: children.map((child) {
              return Tab(
                child: ChildTap(child: child), // 탭에 자녀의 그룹 닉네임 표시
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: children.map((child) {
            return ChildInfo(data: child); // 각 자녀에 대한 정보를 보여주는 위젯
          }).toList(),
        ),
      ),
    );
  }
}
