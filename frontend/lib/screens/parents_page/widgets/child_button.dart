import 'package:flutter/material.dart';

class ChildrenTap extends StatelessWidget {
  const ChildrenTap({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            child: Image.asset(
              'assets/images/whale.png',
              height: 32,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
