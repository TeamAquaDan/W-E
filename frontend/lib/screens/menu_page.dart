import 'package:flutter/material.dart';
import 'package:frontend/screens/my_friends_page.dart';
import 'package:frontend/screens/my_profile_page.dart';
import 'package:frontend/screens/salary_increase_form_page.dart';
import 'package:frontend/screens/salary_list_page.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/salary_increase_page.dart';

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
        ],
      ),
    );
  }
}
