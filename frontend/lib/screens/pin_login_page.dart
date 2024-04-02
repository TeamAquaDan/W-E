import 'package:flutter/material.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
// import '../widgets/nav_bar.dart';
import 'package:frontend/screens/login_page.dart';
import 'dart:developer' as developer;
import 'alarm_page.dart';
import 'child_page/child_page.dart';
import 'dailyword.dart';
import 'dutchpay_page/dutchpay_page.dart';
import 'friends_page/my_friends_page.dart';
import 'mission_page/my_mission_page.dart';
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
          case '101':
            Get.to(() => const MyFriendsPage());
            break;
          case '300':
            Get.to(() => const MyMissionPage());
            break;
          case '301':
            Get.to(() => const MyMissionPage());
            break;
          case '400':
            Get.to(() => const ParentPage());
            break;
          case '401':
            Get.to(() => const SalaryListPage());
            break;
          case '500':
            Get.to(() => const DutchPayPage());
            break;
          case '501':
            Get.to(() => const DutchPayPage());
            break;
          case '502':
            Get.to(() => const DutchPayPage());
            break;
          case '600':
            var userId = Get.find<UserController>().getUserId();
            Get.to(() => MyProfilePage(userId: userId));
            break;
          case '700':
            Get.to(() => const SalaryListPage());
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

  String pin = '';
  @override
  Widget build(BuildContext context) {
    return WithSecureKeyboard(
      controller: _secureKeyboardController,
      child: Scaffold(
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
                      '간편로그인',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Aggro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      showPinKeyBoard();
                    },
                    child: PinKeyboard(
                      pinController: _pinController,
                    )),
                Opacity(
                  opacity: 0.0,
                  child: TextField(
                    maxLength: 6,
                    // onChanged: (value) {
                    //   setState(() {
                    //     pin = value;
                    //   });
                    // },
                    // controller: _pinController,
                    controller: _pinController,
                    focusNode: _pinCodeTextFieldFocusNode,
                    enableInteractiveSelection: false,
                    obscureText: true,
                    onTap: () {
                      showPinKeyBoard();
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'PIN 입력'),
                  ),
                ),
                Container(
                  width: 300.0,
                  height: 56.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF568EF8), // 버튼의 배경색
                    ),
                    onPressed: _checkPin,
                    child: const Text(
                      '로그인',
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
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _navigatedToPinSetting,
                  child: const Text(
                    'PIN 설정',
                    style: TextStyle(
                      color: Color(0xFF568EF8),
                      // fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _authService.logout(); // 로그아웃 수행
                    developer.log('로그아웃 되었습니다.', name: 'logout');

                    // 로그아웃 후 리다이렉션 처리, 예: 로그인 페이지로 이동
                    Get.offAll(() => const LoginPage());
                  },
                  child: const Text('로그아웃'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showPinKeyBoard() {
    _secureKeyboardController.show(
      type: SecureKeyboardType.NUMERIC,
      focusNode: _pinCodeTextFieldFocusNode,
      onKeyPressed: (SecureKeyboardKey key) {
        if (key.action == SecureKeyboardKeyAction.BACKSPACE) {
          if (_pinController.text.isNotEmpty) {
            _pinController.text = _pinController.text
                .substring(0, _pinController.text.length - 1);
            pin = _pinController.text;
          }
        } else if (key.action == SecureKeyboardKeyAction.CLEAR) {
          _pinController.text = '';
          pin = _pinController.text;
        } else {
          if (_pinController.text.length < 6) {
            _pinController.text += key.text ?? '';
            pin = _pinController.text;
          }
        }
      },
    );
  }
  // void showPinKeyBoard() {
  //   _secureKeyboardController.show(
  //     type: SecureKeyboardType.NUMERIC,
  //     focusNode: _pinCodeTextFieldFocusNode,
  //     // initText: _pinController.text,
  //     // hintText: 'pinCode',
  //     onKeyPressed: (SecureKeyboardKey key) {
  //       if (key.action == SecureKeyboardKeyAction.BACKSPACE) {
  //         setState(() {
  //           if (_pinController.text.isNotEmpty) {
  //             _pinController.text = _pinController.text
  //                 .substring(0, _pinController.text.length - 1);
  //             pin = _pinController.text;
  //           }
  //         });
  //       } else if (key.action == SecureKeyboardKeyAction.CLEAR) {
  //         setState(() {
  //           _pinController.text = '';
  //           pin = _pinController.text;
  //         });
  //       } else {
  //         if (pin.length < 6) {
  //           setState(() {
  //             pin += key.text ?? '';
  //             _pinController.text = pin;
  //           });
  //         }
  //       }
  //     },
  //     // onDoneKeyPressed: (List<int> charCodes) {
  //     //   _pinController.text = String.fromCharCodes(charCodes);
  //     // },
  //   );
  // }
}

class PinKeyboard extends StatefulWidget {
  final TextEditingController pinController;

  PinKeyboard({required this.pinController});

  @override
  _PinKeyboardState createState() => _PinKeyboardState();
}

class _PinKeyboardState extends State<PinKeyboard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.pinController,
      builder: (context, value, child) {
        return Container(
          color: Colors.white,
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                6,
                (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 30),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: index < widget.pinController.text.length
                              ? Colors.blue
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )),
          ),
        );
      },
    );
  }
}
