import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/salary_page/salary_increase_form_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalaryIncreasePage extends StatefulWidget {
  const SalaryIncreasePage({
    super.key,
    required this.groupNickname,
    required this.userName,
    required this.groupId,
  });

  final String groupNickname;
  final String userName;
  final int groupId;

  @override
  State<SalaryIncreasePage> createState() => _SalaryIncreasePageState();
}

class _SalaryIncreasePageState extends State<SalaryIncreasePage> {
  final TextEditingController _controller = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.replaceAll(',', '');
      if (text.isNotEmpty) {
        final number = int.tryParse(text);
        if (number != null) {
          _controller.value = TextEditingValue(
            text: _numberFormat.format(number),
            selection: TextSelection.collapsed(
                offset: _numberFormat.format(number).length),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('용돈 인상 신청'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/airplane.png',
                  height: 90,
                ),
              ],
            ),
            const SizedBox(height: 19),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.groupNickname,
                    style: const TextStyle(
                      color: Color(0xFF0014FF),
                      fontSize: 20,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)), // 공간 추가
                  TextSpan(
                    text: '(${widget.userName})',
                    style: const TextStyle(
                      color: Color(0xFF8B7777),
                      fontSize: 20,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)), // 공간 추가
                  const TextSpan(
                    text: '님께',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _controller.text.replaceAll(',', '').length * 12.25 +
                      40.0,
                  height: 48.0,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _controller,
                    onChanged: (String value) {
                      setState(() {}); // 입력이 변경될 때마다 위젯 재구성
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      border: UnderlineInputBorder(),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Text(
                  '원을',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Aggro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '요청할래요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Aggro',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 202, 203, 208)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 162, 172, 219)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                  ),
                  onPressed: () {
                    // 콤마를 제거한 후의 문자열
                    String textWithoutCommas =
                        _controller.text.replaceAll(',', '');
                    // 문자열을 정수로 변환
                    int? negoAmt = int.tryParse(textWithoutCommas);

                    // 정수 변환에 성공했는지 확인
                    if (negoAmt != null) {
                      // 변환에 성공했다면 SalaryIncreaseFormPage로 이동하고 negoAmt를 전달
                      Get.to(() => SalaryIncreaseFormPage(
                            groupId: widget.groupId,
                            negoAmt: negoAmt,
                            userName: widget.userName,
                            groupNickname: widget.groupNickname,
                          ));
                    } else {
                      // 변환에 실패했다면, 예를 들어, 에러 메시지를 표시
                      // 에러 처리 코드를 여기에 추가 (예: 토스트 메시지 표시, 대화 상자 열기 등)
                      print("Invalid input for negoAmt");
                    }
                  }, // api 요청
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
