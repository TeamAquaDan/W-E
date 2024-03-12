import 'package:flutter/material.dart';
import 'package:frontend/widgets/bank_book.dart';
import 'package:frontend/widgets/nav_bar.dart';
import 'package:frontend/widgets/pin_money.dart';
import 'package:get/get.dart';

import 'screens/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavBar(),
    );
  }
}
