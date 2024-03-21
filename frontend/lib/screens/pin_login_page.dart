import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/nav_bar.dart';
import 'package:frontend/screens/login_page.dart';
import 'dart:developer' as developer;
import 'pin_setting_page.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  _PinLoginPageState createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final _pinController = TextEditingController();
  final SecurityService _securityService = SecurityService();
  final AuthService _authService = AuthService();

  void _checkPin() async {
    String? savedPin = await _securityService.getPin();
    if (savedPin == _pinController.text) {
      developer.log('PIN: $savedPin', name: 'saved_pin');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const NavBar()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PIN이 일치하지 않습니다.')));
    }
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
      appBar: AppBar(title: const Text('PIN 입력')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'PIN 입력'),
            ),
            ElevatedButton(
              onPressed: _checkPin,
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: _navigatedToPinSetting,
              child: const Text('PIN 설정'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _authService.logout(); // 로그아웃 수행
                developer.log('로그아웃 되었습니다.', name: 'logout');

                // 로그아웃 후 리다이렉션 처리, 예: 로그인 페이지로 이동
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), // LoginPage는 로그인 페이지의 클래스 이름입니다. 실제 앱에 맞게 조정해야 합니다.
                );
              },
              child: const Text('로그아웃'),
            )
          ],
        ),
      ),
    );
  }
}
