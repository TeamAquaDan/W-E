import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';
import 'pin_login_page.dart';
import 'pin_setting_page.dart';
import '../widgets/nav_bar.dart';
import 'dart:developer' as developer;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // AuthService의 인스턴스 생성
  final AuthService _authService = AuthService();

  void _login() async {
    // 실제 로그인 로직 대신 임시로 로그인 성공 처리
    String loginId = loginIdController.text;
    String password = passwordController.text;

    // AuthService 인스턴스를 통한 login 메소드 호출 및 로그인 성공 여부 검사를 임시로 생략
    bool loginSuccess = await _authService.login(loginId, password);

    developer.log('아이디: ${loginIdController.text}', name: 'signup.data');
    developer.log('비밀번호: ${passwordController.text}', name: 'signup.data');

    // 로그인 성공 시, MyHomePage로 넘어갑니다.
    if (loginSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(),
        ),
      );
    }
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const NavBar()),
    // );

    // 실제 로그인 실패 처리 로직도 임시로 생략
    // else {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('로그인 실패'),
    //         content: const Text('아이디 또는 비밀번호를 확인해주세요.'),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('닫기'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  void _navigateToRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  // void _navigateToPinLoginPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => PinLoginPage()),
  //   );
  // }

  // void _navigatedToPinSetting() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SetPinPage()),
  //   );
  // }
  void _navigateToPinLoginPage() async {
    bool hasLoginInfo = await _authService.hasLoginInfo();
    if (hasLoginInfo) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PinLoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 정보가 없습니다. 먼저 로그인 해주세요.')),
      );
    }
  }

  void _navigatedToPinSetting() async {
    bool hasLoginInfo = await _authService.hasLoginInfo();
    if (hasLoginInfo) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetPinPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 정보가 없습니다. 먼저 로그인 해주세요.')),
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
