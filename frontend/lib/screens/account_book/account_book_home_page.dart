import 'package:flutter/material.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:frontend/screens/account_book/widgets/chart.dart';
import 'package:frontend/screens/account_book/widgets/table.dart';
import 'package:get/get.dart';

class AccountBookHomePage extends StatelessWidget {
  const AccountBookHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('가계부'),
            IconButton(
                onPressed: () {
                  Get.to(() => const FormAccountBook());
                },
                icon: const Icon(Icons.add)),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            AccountBookChart(),
            SizedBox(height: 8),
            AccountBookTable(),
          ],
        ),
      ),
    );
  }
}
