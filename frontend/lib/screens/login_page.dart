import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/child_page/child_page.dart';
import 'package:frontend/screens/parents_page/parent_page.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';
import 'pin_login_page.dart';
import 'pin_setting_page.dart';

import 'dart:developer' as developer;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // AuthService의 인스턴스 생성
  final AuthService _authService = AuthService();

  void _login() async {
    String loginId = loginIdController.text.trim();
    String password = passwordController.text.trim();
    String? fcmToken = globalFCMToken;
    // "eb1ef9fUTEaJUPcJNeg8Xs:APA91bH2j63I6CkFecrF3Psr9YjrvC36vXo4agOSBQzZTa1AHeRLE_vF4hI_Q8ROatDom74L4Vmwaj8qssK120ixSuWnDBIzZrX0a5QcK9GqrXj1WNef2WRIpQYUYs3sbrCPGWjXBJ9i";
    if (fcmToken == null) {
      print("FCM 토큰이 없습니다.");
      return;
    }

    LoginResult loginResult =
        await _authService.login(loginId, password, fcmToken);

    // 로그인 성공 시, Page로 넘어갑니다.
    if (loginResult.isSuccess) {
      developer.log('아이디: $loginId', name: 'signup.data');
      developer.log('비밀번호: $password', name: 'signup.data');
      developer.log('fcm_token: $fcmToken', name: 'fcm_token');

      // 로그인 성공 시, 사용자 역할에 따라 페이지 네비게이션
      if (loginResult.role == 'CHILD') {
        // 자녀 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChildPage()),
        );
      } else if (loginResult.role == 'ADULT') {
        // 부모 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParentPage()),
        );
      } else {
        print("로그인 실패");
      }
    }
  }

  void _navigateToRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  void _navigateToPinLoginPage() async {
    bool hasLoginInfo = await _authService.hasLoginInfo();
    if (hasLoginInfo) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PinLoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 정보가 없습니다. 먼저 로그인 해주세요.')),
      );
    }
  }

  void _navigatedToPinSetting() async {
    bool hasLoginInfo = await _authService.hasLoginInfo();
    if (hasLoginInfo) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SetPinPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 정보가 없습니다. 먼저 로그인 해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("로그인"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: loginIdController,
              decoration: const InputDecoration(
                labelText: '아이디',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true, // 비밀번호를 숨김 처리
              decoration: const InputDecoration(
                labelText: '비밀번호',
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: _navigateToRegistrationPage,
              child: const Text('회원가입'),
            ),
            TextButton(
              onPressed: _navigateToPinLoginPage,
              child: const Text('간편 로그인'),
            ),
            TextButton(
              onPressed: _navigatedToPinSetting,
              child: const Text('PIN 설정'),
            ),
          ],
        ),
      ),
    );
  }
}
