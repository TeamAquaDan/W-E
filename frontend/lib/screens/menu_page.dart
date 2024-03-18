import 'package:flutter/material.dart';
import 'package:frontend/screens/increase_salary_form_page.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/increase_salary_page.dart';

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
                // IncreaseSalary 페이지로 이동
                Get.to(() => IncreaseSalaryPage());
              },
              child: Text('Increase Salary Page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // IncreaseSalary 페이지로 이동
                Get.to(() => IncreaseSalaryFormPage());
              },
              child: Text('Increase Salary Form Page'),
            ),
          ),
        ],
      ),
    );
  }
}
