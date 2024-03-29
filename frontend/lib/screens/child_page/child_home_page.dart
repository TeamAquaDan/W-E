import 'package:flutter/material.dart';
import 'package:frontend/screens/child_page/widgets/goal_card.dart';
import 'package:frontend/screens/child_page/widgets/goal_section_bar.dart';
import 'package:frontend/screens/child_page/widgets/mission_section_bar.dart';
import 'package:frontend/widgets/carousel_with_indicator.dart';
import 'package:frontend/widgets/my_img.dart';

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
              const Spacer(),
              MyProfileIcon(),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselWithIndicator(),
              const SizedBox(height: 16),
              const GoalSectionBar(),
              const GoalCard(),
              const SizedBox(height: 16),
              const MissionSectionBar(),
            ],
          ),
        ));
  }
}
