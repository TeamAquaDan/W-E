import 'package:flutter/material.dart';

class FriendsRequestModal extends StatefulWidget {
  const FriendsRequestModal({
    super.key,
    required this.friendName,
    required this.friendPhoneNumber,
  });

  final String friendName;
  final String friendPhoneNumber;

  @override
  _FriendsRequestModalState createState() => _FriendsRequestModalState();
}

class _FriendsRequestModalState extends State<FriendsRequestModal> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    // 컨트롤러에 초기값 설정
    _nameController = TextEditingController(text: widget.friendName);
    _phoneNumberController =
        TextEditingController(text: widget.friendPhoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('친구 요청'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('이름:'),
            TextField(
              controller: _nameController,
            ),
            SizedBox(height: 8),
            Text('전화번호:'),
            TextField(
              controller: _phoneNumberController,
            ),
          ],
        ),
      ),
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
            // 여기서 _nameController.text와 _phoneNumberController.text로 사용자가 입력한 값에 접근 가능
            // 예를 들어, 여기서 API 호출 등을 통해 서버에 데이터를 전송할 수 있음
            Navigator.of(context).pop(true); // 다이얼로그를 닫고, true 반환
          },
        ),
      ],
    );
  }
}
