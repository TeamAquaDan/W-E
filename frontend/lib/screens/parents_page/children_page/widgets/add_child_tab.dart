import 'package:flutter/material.dart';

class AddChildTap extends StatelessWidget {
  const AddChildTap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey, // 임의의 배경색
          child: Icon(Icons.person), // 아이콘 등으로 대체 가능
        ),
        SizedBox(height: 8),
        Text('자녀추가하기'),
      ],
    );
  }
}
