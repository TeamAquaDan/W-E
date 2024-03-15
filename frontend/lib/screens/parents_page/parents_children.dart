import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/widgets/child_button.dart';
import 'package:frontend/screens/parents_page/widgets/tab_bar.dart';

class ParentsChildren extends StatefulWidget {
  const ParentsChildren({super.key});

  @override
  State<ParentsChildren> createState() => _ParentsChildren();
}

class _ParentsChildren extends State<ParentsChildren> {
  int _selectedIndex = 0;
  static List _widgetOptions = ['김자녀', '김막내'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 자녀 조회'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //자녀 목록 조회 DATA
            Row(
              children: [
                ChildrenButton(
                  name: '김자녀',
                ),
                ChildrenButton(
                  name: '김막내',
                ),
              ],
            ),
          ],
          //자녀 상세 조회
          //미션 목록 조회
        ),
      ),
    );
  }
}

/*
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

"{
  ""status"": 200,
  ""message"": ""자녀 상세 조회 성공"", 
  ""data"": {
     ""user_id"" : int, 자녀 아이디,
     ""group_id"": int, 그룹 아이디
     ""account_num"": ""string, 자녀 계좌번호"",
     ""is_monthly"": ""boolean, 용돈주기(매월)"", 
     ""allowance_amt"": ""int, 용돈 금액"", 
     ""payment_date"": ""int, 용돈 지급일"", 
     ""group_id"": ""int, 그룹아이디""
  }
}"

"{
  ""status"": 200,
  ""message"": ""미션 목록 조회 성공"", 
  ""data"": [
     {
         ""mission_id"" : ""int, 미션 아이디"",
         ""mission_name"": ""string, 미션 제목"",
         ""mission_reward"": ""int, 보상금액"", 
         ""deadline_date"": ""string, 마감 일시"",
         ""status"": ""int, 처리 상태"",
         ""user_name"" : ""string, 미션 제공자 이름""
     },
  ]
}
처리상태 0(진행중), 1(성공), 2(실패)"
*/