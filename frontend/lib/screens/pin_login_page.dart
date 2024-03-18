import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/nav_bar.dart';

class PinLoginPage extends StatefulWidget {
  @override
  _PinLoginPageState createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final _pinController = TextEditingController();
  final SecurityService _securityService = SecurityService();

  void _checkPin() async {
    String? savedPin = await _securityService.getPin();
    if (savedPin == _pinController.text) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavBar()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN이 일치하지 않습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PIN 입력')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'PIN 입력'),
            ),
            ElevatedButton(
              onPressed: _checkPin,
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
