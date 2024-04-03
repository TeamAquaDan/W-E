import 'package:flutter/material.dart';
import 'package:flutter_secure_keyboard/flutter_secure_keyboard.dart';
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
  final _secureKeyboardController = SecureKeyboardController();
  final _pinCodeTextFieldFocusNode = FocusNode();
  final _confirmPinCodeTextFieldFocusNode = FocusNode();
  final _oldPinCodeTextFieldFocusNode = FocusNode();
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
    if (_pinController.text.length != 6 ||
        _confirmPinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN은 6자리여야 합니다.')),
      );
      return;
    }

    // 기존 PIN이 있을 경우, 먼저 기존 PIN 확인
    if (_hasPin &&
        (await _securityService.getPin() != _oldPinController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기존 PIN이 일치하지 않습니다. 다시 시도해주세요.')),
      );
      return;
    }

    // 새 PIN과 확인 PIN 일치 검증
    if (_pinController.text == _confirmPinController.text) {
      await _securityService.setPin(_pinController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const PinLoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN이 일치하지 않습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WithSecureKeyboard(
      controller: _secureKeyboardController,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFF568EF8)),
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
                      'PIN 설정',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Aggro',
                        fontWeight: FontWeight.w700,
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
                  if (_hasPin)
                    TextField(
                      controller: _oldPinController,
                      focusNode: _oldPinCodeTextFieldFocusNode,
                      enableInteractiveSelection: false,
                      obscureText: true,
                      onTap: () {
                        showPinKeyBoard(
                            _oldPinCodeTextFieldFocusNode, _oldPinController);
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '기존 PIN 입력'),
                    ),
                  TextField(
                    controller: _pinController,
                    focusNode: _pinCodeTextFieldFocusNode,
                    enableInteractiveSelection: false,
                    obscureText: true,
                    onTap: () {
                      showPinKeyBoard(
                          _pinCodeTextFieldFocusNode, _pinController);
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '새 PIN 입력'),
                    maxLength: 6, // 최대 길이를 6으로 설정
                  ),
                  TextField(
                    controller: _confirmPinController,
                    focusNode: _confirmPinCodeTextFieldFocusNode,
                    enableInteractiveSelection: false,
                    obscureText: true,
                    onTap: () {
                      showPinKeyBoard(_confirmPinCodeTextFieldFocusNode,
                          _confirmPinController);
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '새 PIN 확인'),
                    maxLength: 6, // 최대 길이를 6으로 설정
                  ),
                  Container(
                    width: 300.0,
                    height: 56.0,
                    child: ElevatedButton(
                      onPressed: _setPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF568EF8), // 버튼의 배경색
                      ),
                      child: const Text(
                        'PIN 설정',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Aggro',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPinKeyBoard(FieldFocusNode, Controller) {
    _secureKeyboardController.show(
      type: SecureKeyboardType.NUMERIC,
      focusNode: FieldFocusNode,
      onKeyPressed: (SecureKeyboardKey key) {
        if (key.action == SecureKeyboardKeyAction.BACKSPACE) {
          if (Controller.text.isNotEmpty) {
            Controller.text =
                Controller.text.substring(0, Controller.text.length - 1);
            // pin = Controller.text;
          }
        } else if (key.action == SecureKeyboardKeyAction.CLEAR) {
          Controller.text = '';
          // pin = Controller.text;
        } else {
          if (Controller.text.length < 6) {
            Controller.text += key.text ?? '';
            // pin = Controller.text;
          }
        }
      },
    );
  }
}
