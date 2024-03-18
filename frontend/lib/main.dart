import 'package:flutter/material.dart';
import 'package:frontend/widgets/nav_bar.dart';
import 'package:get/get.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F62DE)),
        useMaterial3: true,
      ),
      home: const NavBar(),
    );
  }
}
