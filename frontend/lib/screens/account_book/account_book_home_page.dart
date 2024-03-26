import 'package:flutter/material.dart';
import 'package:frontend/screens/account_book/widgets/table.dart';

class AccountBookHomePage extends StatelessWidget {
  const AccountBookHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('가계부'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('data'),
            Text('data'),
            AccountBookTable(),
          ],
        ),
      ),
    );
  }
}
