import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/screens/child_page/child_page.dart';
import 'package:frontend/screens/dailyword.dart';
import 'package:frontend/screens/dutchpay_page/dutchpay_page.dart';
import 'package:frontend/screens/parents_page/children_page/children_carousel.dart';
import 'package:frontend/screens/parents_page/parent_page.dart';
import 'package:frontend/screens/pin_login_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:frontend/api/test_html.dart';
import 'package:frontend/screens/friends_page/my_friends_page.dart';
import 'package:frontend/screens/profile_page/my_profile_page.dart';
import 'package:frontend/screens/saving_goal_page/my_saving_goal_page.dart';
import 'package:frontend/screens/salary_page/salary_list_page.dart';

import 'alarm_page.dart';
import 'child_menu_page.dart';
import 'parent_menu_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const SalaryListPage());
              },
              child: const Text('Salary List Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                var userId = Get.find<UserController>().getUserId();
                Get.to(() => MyProfilePage(userId: userId));
              },
              child: const Text('My Profile Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const MyFriendsPage());
              },
              child: const Text('My Friends Page'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var res = await requestTest();
              Get.snackbar('통신 테스트 결과', res);
            },
            child: const Text('get요청 테스트'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const ChildPage());
            },
            child: const Text('아이 페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const ParentPage());
            },
            child: const Text('부모 페이지'),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const MySavingGoalPage());
              },
              child: const Text('My Saving Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final DioService dioService = DioService();
                try {
                  var response = await dioService.dio.get(
                    '${baseURL}api/allowance/list',
                  );
                  print(response.data);
                } catch (e) {
                  print('Error: 에러 $e');
                }
              },
              child: const Text('용돈 목록 조회 get 요청 테스트'),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const AlarmPage());
              },
              child: const Text('Notify')),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const PinLoginPage());
              },
              child: const Text('핀로그인/로그아웃')),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const DutchPayPage());
              },
              child: const Text('더치페이 ')),
          ElevatedButton(
              onPressed: () {
                Get.to(const ChildrenManagePage2());
              },
              child: const Text('아이 조회 페이지')),
          ElevatedButton(
              onPressed: () {
                Get.to(const DailyWord());
              },
              child: const Text('일일 단어')),
          ElevatedButton(
              onPressed: () {
                Get.to(ChildMenuPage());
              },
              child: const Text('아이 메뉴')),
          ElevatedButton(
              onPressed: () {
                Get.to(ParentMenuPage());
              },
              child: const Text('부모 메뉴')),
        ],
      ),
    );
  }
}
