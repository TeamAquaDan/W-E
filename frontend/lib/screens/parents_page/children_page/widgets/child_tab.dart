import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';

class ChildTap extends StatelessWidget {
  final Child child;

  const ChildTap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(child.profileImage),
        ),
        const SizedBox(height: 8),
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
