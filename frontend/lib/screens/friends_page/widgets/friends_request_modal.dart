import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/services/dio_service.dart';

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
            const Text('이름:'),
            TextField(
              controller: _nameController,
            ),
            const SizedBox(height: 8),
            const Text('전화번호:'),
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
          onPressed: () async {
            final DioService dioService = DioService();
            try {
              var response = await dioService.dio.post(
                '${baseURL}api/user/verify',
                data: {
                  "phone_num": _phoneNumberController.text,
                  "username": _nameController.text,
                },
              );
              if (response.statusCode == 200) {
                // 친구 요청하는 코드
                print('존재하는 친구임 ㅇㅇ');
                print('response.data: ${response.data['data']['user_id']}');
                DioService dioService = DioService();
                dioService.dio.post(
                  '${baseURL}api/friend/register',
                  data: {
                    "user_id": response.data['data']['user_id'],
                  },
                ).then((res) {
                  print('친구 요청 보냄 $res');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("친구 요청을 보냈습니다."),
                    ),
                  );
                  Navigator.pop(context, true);
                }).catchError((err) {
                  print('친구 요청 보내기 실패 $err');
                  Navigator.pop(context, true);
                });
              } else if (response.statusCode == 404) {
                // 사용자가 존재하지 않는 경우
                print('존재하지 않는 친구임 ㅇㅇ');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("사용자가 존재하지 않습니다."),
                  ),
                );
              }
            } catch (e) {
              if (e is DioError) {
                // DioError를 통해 에러를 더 세분화하여 처리
                if (e.response?.statusCode == 404) {
                  // 사용자가 존재하지 않는 경우
                  print('존재하지 않는 친구임 ㅇㅇ');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("사용자가 존재하지 않습니다."),
                    ),
                  );
                }
              }
              Navigator.of(context).pop(true); // 다이얼로그를 닫고, true 반환
            }
          },
        ),
      ],
    );
  }
}
