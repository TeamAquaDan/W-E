import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/screens/login_page.dart';
import 'package:frontend/screens/pin_login_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F62DE)),
        primarySwatch: Colors.blue,
        // 텍스트 필드의 스타일을 정의합니다.
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 20), // labelText의 크기를 크게 설정합니다.
          border: OutlineInputBorder(), // 외곽에 테두리를 추가합니다.
          // 추가적으로 테두리의 스타일이나 색상을 조정할 수 있습니다.
          // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2.0)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
      home: FutureBuilder(
        future: _authService.tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // 로딩 인디케이터 표시
          } else {
            if (snapshot.data == true) {
              return PinLoginPage(); // 자동 로그인 성공 시 간편 로그인 페이지로 이동
            } else {
              return LoginPage(); // 로그인 정보 없음 또는 실패 시 로그인 페이지로 이동
            }
          }
        },
      ),
    );
  }
}
