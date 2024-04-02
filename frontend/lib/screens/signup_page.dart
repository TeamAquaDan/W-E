import 'package:flutter/material.dart';
import 'package:frontend/widgets/auth_text_field.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'dart:developer' as developer;

void myFunction() {
  developer.log('이곳에 로그 메시지를 입력', name: 'my.app.category');
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

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
  bool isFailed = false;
  final FocusNode _birthdateFocusNode = FocusNode();
  final FocusNode _rrNumberFocusNode = FocusNode();
  Future<void> _signUp() async {
    // 비밀번호와 비밀번호 확인이 같은지 확인
    if (_passwordController.text != _confirmPasswordController.text) {
      // 사용자에게 경고 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호와 비밀번호 확인이 일치하지 않습니다.')),
      );
      return;
    }
    // 아이디 형식 검증
    if (!RegExp(r'^[a-zA-Z0-9]{5,20}$').hasMatch(_loginIdController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디는 5~20자의 영문자와 숫자만 사용 가능합니다.')),
      );
      return;
    }

    // 비밀번호 형식 검증
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$')
        .hasMatch(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('비밀번호는 최소 8자 이상이며, 대소문자, 숫자, 특수문자를 모두 포함해야 합니다.')),
      );
      return;
    }
    bool success = await _authService.signUp(
      _loginIdController.text,
      _passwordController.text,
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

    if (success) {
      // 회원가입 성공
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공!')),
      );
      _navigateToLoginScreen();
    } else {
      // 회원가입 실패
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 실패. 다시 시도해주세요.')),
      );
    }
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
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
              AuthTextField(
                  controller: _usernameController,
                  isFailed: isFailed,
                  label: '실명',
                  isBlind: false),
              TextField(
                controller: _birthdateController,
                decoration: const InputDecoration(labelText: '주민번호 앞 6자리'),
                maxLength: 6,
                keyboardType: TextInputType.number,
                focusNode: _birthdateFocusNode,
                onChanged: (value) {
                  if (_birthdateController.text.length >= 6) {
                    _birthdateFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_rrNumberFocusNode);
                  }
                },
              ),
              TextField(
                controller: _rrNumberController,
                decoration: const InputDecoration(labelText: '주민번호 뒷 7자리'),
                maxLength: 7,
                keyboardType: TextInputType.number,
                obscureText: true,
                focusNode: _rrNumberFocusNode,
              ),
              AuthTextField(
                  controller: _loginIdController,
                  isFailed: isFailed,
                  label: '아이디',
                  isBlind: false),
              AuthTextField(
                  controller: _passwordController,
                  isFailed: isFailed,
                  label: '비밀번호',
                  isBlind: true),
              AuthTextField(
                  controller: _confirmPasswordController,
                  isFailed: isFailed,
                  label: '비밀번호 확인',
                  isBlind: true),
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
