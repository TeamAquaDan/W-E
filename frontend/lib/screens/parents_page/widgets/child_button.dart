import 'package:flutter/material.dart';

class ChildrenButton extends StatelessWidget {
  const ChildrenButton({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {},
        child: Column(
          children: [
            CircleAvatar(
              child: Image.asset(
                'assets/images/whale.png',
                height: 32,
              ),
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}
