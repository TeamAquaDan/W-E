import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // SecurityService 구현을 포함한 파일을 참조하세요.
import 'pin_login_page.dart'; // PinLoginPage 구현을 포함한 파일을 참조하세요.

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _oldPinController = TextEditingController(); // 기존 PIN 입력을 위한 컨트롤러
  final SecurityService _securityService = SecurityService();
  final AuthService _authService = AuthService();

  bool _hasPin = false;

  @override
  void initState() {
    super.initState();
    _checkForExistingPin();
  }

  void _checkForExistingPin() async {
    _hasPin = await _authService.hasPin();
    setState(() {});
  }

  void _setPin() async {
    // PIN 길이 검증
    if (_pinController.text.length != 6 || _confirmPinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN은 6자리여야 합니다.')),
      );
      return;
    }

    // 기존 PIN이 있을 경우, 먼저 기존 PIN 확인
    if (_hasPin && (await _securityService.getPin() != _oldPinController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기존 PIN이 일치하지 않습니다. 다시 시도해주세요.')),
      );
      return;
    }

    // 새 PIN과 확인 PIN 일치 검증
    if (_pinController.text == _confirmPinController.text) {
      await _securityService.setPin(_pinController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinLoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN이 일치하지 않습니다. 다시 시도해주세요.')),
      );
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
            if (_hasPin)
              TextField(
                controller: _oldPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '기존 PIN 입력'),
              ),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '새 PIN 입력'),
              maxLength: 6, // 최대 길이를 6으로 설정
            ),
            TextField(
              controller: _confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '새 PIN 확인'),
              maxLength: 6, // 최대 길이를 6으로 설정
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
