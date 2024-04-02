import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/child_page/child_page.dart';
import 'package:frontend/screens/parents_page/parent_page.dart';
import 'package:frontend/widgets/auth_text_field.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';
import 'pin_login_page.dart';
import 'pin_setting_page.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'dart:developer' as developer;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoginFailed = false;
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
    try {
      LoginResult loginResult =
          await _authService.login(loginId, password, fcmToken);
      // _callSnackBar();
      // 로그인 성공 시, Page로 넘어갑니다.
      if (loginResult.isSuccess) {
        developer.log('아이디: $loginId', name: 'signup.data');
        developer.log('비밀번호: $password', name: 'signup.data');
        developer.log('fcm_token: $fcmToken', name: 'fcm_token');

        // 로그인 성공 시, 사용자 역할에 따라 페이지 네비게이션
        if (loginResult.role == 'CHILD') {
          // 아이 페이지로 이동
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
          setState(() {
            _isLoginFailed = true;
          });
          _callSnackBar();
        }
      } else {
        // print("로그인 실패");
        setState(() {
          _isLoginFailed = true;
        });
        _callSnackBar();
      }
    } catch (error) {
      setState(() {
        _isLoginFailed = true;
      });
      _callSnackBar();
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

  void _callSnackBar() {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: '로그인 실패',
        message: '정확한 아이디와 비밀번호를 입력해주세요',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF568EF8),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            // height: 100,
            decoration: BoxDecoration(color: Color(0xFF568EF8)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Text(
                    '로그인',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                AuthTextField(
                    controller: loginIdController,
                    isFailed: _isLoginFailed,
                    label: '아이디',
                    isBlind: false),
                const SizedBox(height: 15),
                AuthTextField(
                    controller: passwordController,
                    isFailed: _isLoginFailed,
                    label: '비밀번호',
                    isBlind: true),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF568EF8)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 테두리 곡률 설정
                        ),
                      ), // 버튼 색상 설정
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('계정이 없으신가요? '),
                    TextButton(
                      onPressed: _navigateToRegistrationPage,
                      child: const Text('회원가입'),
                    ),
                  ],
                ),
                // TextButton(
                //   onPressed: _navigateToPinLoginPage,
                //   child: const Text('간편 로그인'),
                // ),
                // TextButton(
                //   onPressed: _navigatedToPinSetting,
                //   child: const Text('PIN 설정'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
