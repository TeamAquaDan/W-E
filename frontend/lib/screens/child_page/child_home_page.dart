import 'package:flutter/material.dart';
import 'package:frontend/screens/child_page/widgets/goal_card.dart';
import 'package:frontend/screens/child_page/widgets/goal_section_bar.dart';
import 'package:frontend/screens/saving_goal_page/my_saving_goal_page.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal.dart';
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
              const SizedBox(height: 16),
              GoalSectionBar(),
              GoalCard(),
            ],
          ),
        ));
  }
}
