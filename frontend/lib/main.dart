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
