import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/child_page/child_page.dart';
import 'package:frontend/screens/salary_page/salary_list_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalaryIncreaseFormPage extends StatefulWidget {
  const SalaryIncreaseFormPage({
    super.key,
    required this.negoAmt,
    required this.groupId,
    required this.userName,
    required this.groupNickname,
  });

  final int negoAmt;
  final int groupId;
  final String userName;
  final String groupNickname;

  @override
  State<SalaryIncreaseFormPage> createState() => _SalaryIncreaseFormPageState();
}

class _SalaryIncreaseFormPageState extends State<SalaryIncreaseFormPage> {
  final TextEditingController _textController = TextEditingController();

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('용돈 인상 신청'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(45), // 여기에 원하는 패딩 값을 설정
          child: SingleChildScrollView(
            // 스크롤 가능한 뷰 추가
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
              children: [
                // 타이틀 텍스트
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.groupNickname,
                        style: const TextStyle(
                          color: Color(0xFF0014FF),
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' (${widget.userName}) ',
                        style: const TextStyle(
                          color: Color(0xFF8B7777),
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: '님께',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // 금액 텍스트
                Text(
                  '${formatNumber(widget.negoAmt)}원을',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                // 요청 텍스트
                const Text(
                  '요청할래요!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                // 여기에 사용자 입력을 받을 TextField를 추가할 수 있습니다.
                // 예를 들어, TextFormField 또는 TextField 위젯을 사용하여 구현할 수 있습니다.
                // 예시:
                TextField(
                  controller: _textController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: "이유를 작성해주세요",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    fillColor: const Color.fromARGB(179, 86, 77, 77),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 9, // 여러 줄의 텍스트 입력을 허용
                ),
                const SizedBox(height: 50),
                // 요청하기 버튼
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF568EF8), // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      print(_textController.text);
                      final DioService dioService = DioService();

                      try {
                        var response = await dioService.dio.post(
                          '${baseURL}api/nego',
                          data: {
                            'group_id': widget.groupId,
                            'nego_amt': widget.negoAmt,
                            'nego_reason': _textController.text,
                          },
                        );
                        Get.offAll(() => const ChildPage());
                        print(response);
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    child: const Text(
                      '요청하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
