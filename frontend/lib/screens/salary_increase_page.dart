import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/salary_increase_form_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalaryIncreasePage extends StatefulWidget {
  const SalaryIncreasePage({super.key});

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
        title: Text('용돈 인상 신청'),
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
            SizedBox(height: 19),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '보호자',
                    style: TextStyle(
                      color: Color(0xFF0014FF),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  WidgetSpan(child: SizedBox(width: 8)), // 공간 추가
                  TextSpan(
                    text: '(실명)',
                    style: TextStyle(
                      color: Color(0xFF8B7777),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  WidgetSpan(child: SizedBox(width: 8)), // 공간 추가
                  TextSpan(
                    text: '님께',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
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
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      border: UnderlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '원을',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              '요청할래요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 202, 203, 208)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.fromLTRB(20, 10, 20, 10)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 162, 172, 219)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.fromLTRB(20, 10, 20, 10)),
                  ),
                  onPressed: () {
                    print(_controller.text.replaceAll(',', ''));
                    Get.to(() => SalaryIncreaseFormPage());
                  }, // api 요청
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Roboto',
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
