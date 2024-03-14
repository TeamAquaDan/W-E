import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/widgets/child_button.dart';

class ParentsChildren extends StatelessWidget {
  const ParentsChildren({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 자녀 조회'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            children: [
              ChildrenButton(
                name: '김자녀',
              ),
              ChildrenButton(
                name: '김막내',
              ),
            ],
          ),
        ],
      )),
    );
  }
}
