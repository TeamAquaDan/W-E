import 'package:flutter/material.dart';

class IncreaseSalaryFormPage extends StatefulWidget {
  const IncreaseSalaryFormPage({super.key});

  @override
  State<IncreaseSalaryFormPage> createState() => _IncreaseSalaryFormPageState();
}

class _IncreaseSalaryFormPageState extends State<IncreaseSalaryFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('용돈 인상 신청'),
      ),
      body: Padding(
        padding: EdgeInsets.all(45), // 여기에 원하는 패딩 값을 설정
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
                      text: '보호자',
                      style: TextStyle(
                        color: Color(0xFF0014FF),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' (실명) ',
                      style: TextStyle(
                        color: Color(0xFF8B7777),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
              ),
              SizedBox(height: 10),
              // 금액 텍스트
              Text(
                '50,000원을',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              // 요청 텍스트
              Text(
                '요청할래요!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),

              // 여기에 사용자 입력을 받을 TextField를 추가할 수 있습니다.
              // 예를 들어, TextFormField 또는 TextField 위젯을 사용하여 구현할 수 있습니다.
              // 예시:
              TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: "이유를 입력하세요",
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  fillColor: Color.fromARGB(179, 86, 77, 77),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 6, // 여러 줄의 텍스트 입력을 허용
              ),
              SizedBox(height: 20),
              // 요청하기 버튼
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0014FF), // 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    // 버튼 클릭 이벤트 처리
                  },
                  child: Text(
                    '요청하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
