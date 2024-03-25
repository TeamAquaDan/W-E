import 'package:flutter/material.dart';
import 'package:frontend/widgets/carousel_with_indicator.dart';

class ChildHomePage extends StatelessWidget {
  const ChildHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/whale.png',
                height: 32,
              ),
              const Text('Whale 자녀 페이지'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselWithIndicator(),
            ],
          ),
        ));
  }
}
