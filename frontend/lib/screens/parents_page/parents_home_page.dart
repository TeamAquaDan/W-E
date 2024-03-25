import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/widgets/section_bar.dart';
import 'package:frontend/widgets/carousel_with_indicator.dart';
import 'package:frontend/screens/misson_page/widgets/mission_none.dart';
import 'package:frontend/widgets/pin_money.dart';

class ParentsHomePage extends StatelessWidget {
  const ParentsHomePage({super.key});

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
            const Text('Whale 부모 페이지'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselWithIndicator(),
              const SizedBox(height: 16),
              const SectionBar(title: '자녀 용돈 목록'),
              const Column(
                children: [
                  PinMoney(
                    PinMoneyDay: 16,
                    PinMoneyMoney: 100000,
                    childName: '김자녀',
                  ),
                  PinMoney(
                    PinMoneyDay: 16,
                    PinMoneyMoney: 50000,
                    childName: '김막내',
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const SectionBar(title: '진행 중인 미션'),
              const MissionNone(),
            ],
          ),
        ),
      ),
    );
  }
}

/*자녀 목록 조회 
"{
  ""status"": 200,
  ""message"": ""자녀 목록 조회 성공"", 
  ""data"": [
     {
         ""user_id"" ; int, 자녀 아이디,
         ""group_id"" : int, 그룹 아이디
         ""profile_image"": ""string, 자녀 프로필이미지"", 
         ""group_nickname"": ""string, 그룹 별칭""
     },
  ]
}"

*/