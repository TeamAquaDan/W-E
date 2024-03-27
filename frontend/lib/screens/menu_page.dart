import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/account_book/account_book_page.dart';

import 'package:frontend/screens/child_page/child_page.dart';
import 'package:frontend/screens/parents_page/parent_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:frontend/api/test_html.dart';
import 'package:frontend/screens/friends_page/my_friends_page.dart';
import 'package:frontend/screens/profile_page/my_profile_page.dart';
import 'package:frontend/screens/saving_goal_page/my_saving_goal_page.dart';
import 'package:frontend/screens/salary_page/salary_increase_form_page.dart';
import 'package:frontend/screens/salary_page/salary_list_page.dart';
import 'package:frontend/screens/salary_page/salary_increase_page.dart';

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
                Get.to(() => const SalaryIncreasePage());
              },
              child: const Text('Increase Salary Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const SalaryIncreaseFormPage());
              },
              child: const Text('Increase Salary Form Page'),
            ),
          ),
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
                Get.to(() => const MyProfilePage());
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
              var res = await request();
              Get.snackbar('통신 테스트 결과', res);
            },
            child: const Text('get요청 테스트'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const ChildPage());
            },
            child: const Text('자녀 페이지'),
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
                Get.to(() => const AccountBookPage());
              },
              child: const Text('AccountBookPage'))
        ],
      ),
    );
  }
}
