import 'package:flutter/material.dart';

class FriendsRequestModal extends StatelessWidget {
  const FriendsRequestModal({super.key, required this.friendName});

  final String friendName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('친구 요청'),
      content: Text('$friendName님에게 친구 요청을 하시겠습니까?'),
      actions: <Widget>[
        TextButton(
          child: const Text('아니오'),
          onPressed: () {
            Navigator.of(context).pop(false); // 다이얼로그를 닫고, false 반환
          },
        ),
        TextButton(
          child: const Text('예'),
          onPressed: () {
            Navigator.of(context).pop(true); // 다이얼로그를 닫고, true 반환
          },
        ),
      ],
    );
  }
}
