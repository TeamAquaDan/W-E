import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/models/store/user/user_controller.dart';

import '../services/auth_service.dart';
import 'dailyword.dart';
import 'dutchpay_page/dutchpay_page.dart';
import 'friends_page/my_friends_page.dart';
import 'login_page.dart';
import 'parents_page/children_page/children_carousel.dart';
import 'profile_page/my_profile_page.dart';
import 'salary_page/salary_list_page.dart';
import 'saving_goal_page/my_saving_goal_page.dart';

class ParentMenuPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Hex 색상 코드를 Flutter의 Color 객체로 변환
    final dividerColor = Color(0xFF568EF8).withOpacity(0.7);
    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 메뉴'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('내 아이 목록'),
              onTap: () {
                // '마이페이지' 메뉴 항목 클릭 시 수행할 동작
                Get.to(() => const ChildrenManagePage2());
              },
            ),
            Divider(color: dividerColor),
            ListTile(
              title: const Text('오늘의 단어'),
              onTap: () {
                // '마이페이지' 메뉴 항목 클릭 시 수행할 동작
                Get.to(() => const DailyWord());
              },
            ),
            Divider(color: dividerColor),
            ListTile(
              title: const Text('로그아웃'),
              onTap: () async {
                // '마이페이지' 메뉴 항목 클릭 시 수행할 동작
                await _authService.logout(); // 로그아웃 수행
                Get.offAll(() => LoginPage());
              },
            ),
            Divider(color: dividerColor),
            // 다른 메뉴 항목들도 위와 같은 방식으로 추가...
          ],
        ),
      ),
    );
  }
}
