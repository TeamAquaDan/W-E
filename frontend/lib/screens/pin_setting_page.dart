import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 
import '../screens/pin_login_page.dart';

class SetPinPage extends StatefulWidget {
  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final SecurityService _securityService = SecurityService();

  void _setPin() async {
    if (_pinController.text == _confirmPinController.text) {
      await _securityService.setPin(_pinController.text);
      // PIN 설정 후 로직, 예를 들어 홈 화면으로 이동
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => PinLoginPage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: const Text('PIN이 일치하지 않습니다. 다시 시도해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PIN 설정')),
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
            TextField(
              controller: _confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'PIN 확인'),
            ),
            ElevatedButton(
              onPressed: _setPin,
              child: const Text('PIN 설정'),
            ),
          ],
        ),
      ),
    );
  }
}
