import 'package:flutter/material.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
// import '../widgets/nav_bar.dart';
import 'package:frontend/screens/login_page.dart';
import 'dart:developer' as developer;
import 'alarm_page.dart';
import 'child_page/child_page.dart';
import 'friends_page/my_friends_page.dart';
import 'parents_page/parent_page.dart';
import 'pin_setting_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'profile_page/my_profile_page.dart';
import 'salary_page/salary_list_page.dart';
import 'package:flutter_secure_keyboard/flutter_secure_keyboard.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  _PinLoginPageState createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  // final _pinController = TextEditingController();
  final SecurityService _securityService = SecurityService();
  final AuthService _authService = AuthService();
  RemoteMessage? _initialMessage;
  final _secureKeyboardController = SecureKeyboardController();
  final _pinController = TextEditingController();
  final _pinCodeTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _checkForInitialMessage();
  }

  Future<void> _checkForInitialMessage() async {
    _initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  }

  void _checkPin() async {
    String? savedPin = await _securityService.getPin();
    // 사용자 역할 정보를 로컬 스토리지에서 조회
    String? userRole = await _authService.getUserRole();
    if (savedPin == _pinController.text) {
      // 초기 알림 데이터가 없으면 사용자 역할에 따라 페이지 이동
      _navigateBasedOnRole(userRole);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PIN이 일치하지 않습니다.')));
    }
  }

  void _navigateBasedOnRole(String? role) {
    if (role == 'CHILD') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ChildPage()));
      if (_initialMessage != null) {
        // 초기 알림 데이터가 있으면 처리
        handleNotificationClick(_initialMessage);
      }
    } else if (role == 'ADULT') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ParentPage()));
      if (_initialMessage != null) {
        // 초기 알림 데이터가 있으면 처리
        handleNotificationClick(_initialMessage);
      }
    } else {
      // 역할이 없거나 다른 경우, 로그인 페이지로 이동
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  void handleNotificationClick(RemoteMessage? message) {
    if (message != null) {
      final category = message.data['category'];
      developer.log('Handle notification click with category: $category',
          name: 'NotificationClick');
      // 여기에 실제 페이지 이동 로직 추가
      if (category != null) {
        switch (category) {
          case '100':
            Get.to(() => const MyFriendsPage());
            break;
          case '400':
            Get.to(() => const SalaryListPage());
            break;
          case '600':
            var userId = Get.find<UserController>().getUserId();
            Get.to(() => MyProfilePage(userId: userId));
            break;
          default:
            Get.to(() => const AlarmPage());
            break;
        }
      }
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
    return WithSecureKeyboard(
      controller: _secureKeyboardController,
      child: Scaffold(
        appBar: AppBar(title: const Text('PIN 입력')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                // controller: _pinController,
                controller: _pinController,
                focusNode: _pinCodeTextFieldFocusNode,
                enableInteractiveSelection: false,
                obscureText: true,
                onTap: () {
                  _secureKeyboardController.show(
                    type: SecureKeyboardType.NUMERIC,
                    focusNode: _pinCodeTextFieldFocusNode,
                    initText: _pinController.text,
                    hintText: 'pinCode',
                    // Use onDoneKeyPressed to allow text to be entered when you press the done key,
                    // or to do something like encryption.
                    onDoneKeyPressed: (List<int> charCodes) {
                      _pinController.text = String.fromCharCodes(charCodes);
                    },
                  );
                },
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
      ),
    );
  }
}
