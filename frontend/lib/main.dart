// import 'package:flutter/material.dart';
// import 'package:frontend/widgets/bank_book.dart';
// import 'package:frontend/widgets/nav_bar.dart';
// import 'package:frontend/widgets/pin_money.dart';
// import 'package:get/get.dart';
// import 'package:frontend/screens/login_page.dart';

// import 'screens/my_home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: LoginPage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/screens/login_page.dart';
import 'package:frontend/widgets/nav_bar.dart'; // 자동 로그인 성공 시 이동할 메인 페이지

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _authService.tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // 로딩 인디케이터 표시
          } else {
            if (snapshot.data == true) {
              return const NavBar(); // 자동 로그인 성공 시 메인 페이지로 이동
            } else {
              return LoginPage(); // 로그인 정보 없음 또는 실패 시 로그인 페이지로 이동
            }
          }
        },
      ),
    );
  }
}
