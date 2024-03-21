import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/future_test.dart';
import 'package:get/get.dart';
import 'package:frontend/api/test_html.dart';
import 'package:frontend/screens/friends_page/my_friends_page.dart';
import 'package:frontend/screens/profile_page/my_profile_page.dart';
import 'package:frontend/screens/saving_goal_page/my_saving_goal_page.dart';
import 'package:frontend/screens/salary_page/salary_increase_form_page.dart';
import 'package:frontend/screens/salary_page/salary_list_page.dart';
import 'package:get/get.dart';
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
                Get.to(() => SalaryIncreasePage());
              },
              child: Text('Increase Salary Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => SalaryIncreaseFormPage());
              },
              child: Text('Increase Salary Form Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => SalaryListPage());
              },
              child: Text('Salary List Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => MyProfilePage());
              },
              child: Text('My Profile Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => MyFriendsPage());
              },
              child: Text('My Friends Page'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var res = await request();
              Get.snackbar('통신 테스트 결과', res);
            },
            child: Text('get요청 테스트'),
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => MyStatelessWidget());
                  },
                  child: Text('FutureBuilder 테스트'))),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => MySavingGoalPage());
              },
              child: Text('My Saving Page'),
            ),
          ),
        ],
      ),
    );
  }
}
