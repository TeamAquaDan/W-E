// import 'package:flutter/material.dart';
// import '../models/signup_request.dart'; // SignupRequest 모델 import 확인
// import '../services/auth_service.dart'; // AuthService 로직 import 확인

// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();
//   final loginIdController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final usernameController = TextEditingController();
//   final birthdateController = TextEditingController();
//   final rrNumberController = TextEditingController();

//   void _signup() async {
//     if (_formKey.currentState!.validate()) {
//       // 모델 인스턴스 생성
//       SignupRequest request = SignupRequest(
//         login_id: loginIdController.text,
//         password: passwordController.text,
//         confirmpassword: confirmPasswordController.text,
//         username: usernameController.text,
//         birthdate: birthdateController.text,
//         rr_number: rrNumberController.text,
//       );
//       // 회원가입 요청
//       bool success = await AuthService().signUp(request);
//       if (success) {
//         // 회원가입 성공 시 처리, 예: 로그인 페이지로 이동
//         Navigator.pop(context);
//       } else {
//         // 회원가입 실패 시 처리
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('회원가입')),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView( // 스크롤 가능하게 만듭니다.
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: <Widget>[
//               TextFormField(
//                 controller: loginIdController,
//                 decoration: const InputDecoration(labelText: '아이디'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '아이디를 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(labelText: '비밀번호'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '비밀번호를 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: confirmPasswordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(labelText: '비밀번호 확인'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '비밀번호 확인을 입력해주세요.';
//                   }
//                   if (passwordController.text != value) {
//                     return '비밀번호가 일치하지 않습니다.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: usernameController,
//                 decoration: const InputDecoration(labelText: '실명'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '실명을 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: birthdateController,
//                 decoration: const InputDecoration(labelText: '주민번호 앞 6자리'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '주민번호 앞 6자리를 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: rrNumberController,
//                 decoration: const InputDecoration(labelText: '주민번호 뒤 7자리'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '주민번호 뒤 7자리를 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _signup,
//                 child: const Text('회원가입'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// signup_page.dart
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
