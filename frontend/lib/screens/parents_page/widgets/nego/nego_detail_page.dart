import 'package:flutter/material.dart';
import 'package:frontend/api/nego/nego_list_api.dart';
import 'package:frontend/screens/parents_page/parent_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NegoDetailPage extends StatefulWidget {
  const NegoDetailPage({
    super.key,
    required this.nego,
    required this.groupNickname,
  });

  final Map<String, dynamic> nego;
  final String groupNickname;

  @override
  State<NegoDetailPage> createState() => _NegoDetailPageState();
}

class _NegoDetailPageState extends State<NegoDetailPage> {
  TextEditingController _textController = TextEditingController();

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.nego['nego_reason']);
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
              crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
              children: [
                // 타이틀 텍스트
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.groupNickname}',
                        style: const TextStyle(
                          color: const Color(0xFF568EF8),
                          fontSize: 20,
                          fontFamily: 'Aggro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: '님이',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Aggro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // 금액 텍스트
                Text(
                  '${formatNumber(widget.nego['nego_amt'])}원을',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Aggro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                // 요청 텍스트
                const Text(
                  '인상을 요청했어요!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Aggro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _textController,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    fillColor: const Color(0XFFEFEFEF),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 7, // 여러 줄의 텍스트 입력을 허용
                ),
                const SizedBox(height: 20),
                // 요청하기 버튼
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor:
                              const Color.fromARGB(255, 153, 153, 153),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        child: const Text(
                          "거절",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27.50,
                            fontFamily: 'Aggro',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () {
                          patchNego(
                              negoId: widget.nego['nego_id'],
                              result: 2,
                              comment: _textController.text);
                          Get.offAll(const ParentPage());
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: const Color(0xFF568EF8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        child: const Text(
                          "승인",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27.50,
                            fontFamily: 'Aggro',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        onPressed: () {
                          // 변경된 그룹 닉네임을 서버로 전송
                          patchNego(
                              negoId: widget.nego['nego_id'],
                              result: 1,
                              comment: _textController.text);
                          Get.offAll(const ParentPage());
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
