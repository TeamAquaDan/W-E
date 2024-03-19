import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'dart:developer' as developer;

void myFunction() {
  developer.log('이곳에 로그 메시지를 입력', name: 'my.app.category');
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _rrNumberController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _signUp() async {
    bool success = await _authService.signUp(
      _loginIdController.text,
      _passwordController.text,
      _confirmPasswordController.text,
      _usernameController.text,
      _birthdateController.text,
      _rrNumberController.text,
    );
    // 사용자 입력 데이터 로깅
    developer.log('실명: ${_usernameController.text}', name: 'signup.data');
    developer.log('주민번호 앞 6자리: ${_birthdateController.text}',
        name: 'signup.data');
    developer.log('주민번호 뒷 7자리: ${_rrNumberController.text}',
        name: 'signup.data');
    developer.log('아이디: ${_loginIdController.text}', name: 'signup.data');
    developer.log('비밀번호: ${_passwordController.text}', name: 'signup.data');
    developer.log('비밀번호 확인: ${_confirmPasswordController.text}',
        name: 'signup.data');

    _navigateToLoginScreen();
    // if (success) {
    //   // 회원가입 성공
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('회원가입 성공!')),
    //   );
    // } else {
    //   // 회원가입 실패
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('회원가입 실패. 다시 시도해주세요.')),
    //   );
    // }
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: '실명'),
              ),
              TextField(
                controller: _birthdateController,
                decoration: const InputDecoration(labelText: '주민번호 앞 6자리'),
              ),
              TextField(
                controller: _rrNumberController,
                decoration: const InputDecoration(labelText: '주민번호 뒷 7자리'),
              ),
              TextField(
                controller: _loginIdController,
                decoration: const InputDecoration(labelText: '아이디'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signUp();
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
