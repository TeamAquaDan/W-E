import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';

class ChildTap extends StatelessWidget {
  final Child child;

  const ChildTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (child.profileImage != null)
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(child.profileImage!),
          )
        else
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey, // 임의의 배경색
            child: Icon(Icons.person), // 아이콘 등으로 대체 가능
          ),
        SizedBox(height: 8),
        Text(
          child.groupNickname,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
