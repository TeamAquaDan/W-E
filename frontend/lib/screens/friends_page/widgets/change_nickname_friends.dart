import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/services/dio_service.dart';

Future<String?> showChangeNicknameFriendsDialog(BuildContext context,
    String currentNickname, int userId, Function onSuccess) async {
  TextEditingController nicknameController =
      TextEditingController(text: currentNickname);
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('별칭 변경'),
        content: TextField(
          controller: nicknameController,
          decoration: const InputDecoration(
            hintText: '새로운 별칭을 입력하세요',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff777777),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF568EF8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  // async 추가
                  final DioService dioService = DioService();
                  try {
                    // await 키워드를 사용하여 비동기 요청의 결과를 기다림
                    var response = await dioService.dio.patch(
                      '${baseURL}api/friend/nickname',
                      data: {
                        'user_id': userId,
                        'nickname': nicknameController.text,
                      },
                    );
                    // 요청이 성공적으로 완료되면 응답을 콘솔에 출력
                    print(response.data);
                    onSuccess();
                  } catch (e) {
                    print(e);
                  }
                  Navigator.of(context).pop(nicknameController.text);
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
