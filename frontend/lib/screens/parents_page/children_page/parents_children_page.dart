import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/children_page/child_info.dart';
import 'package:frontend/screens/parents_page/widgets/child_button.dart';

class ParentsChildrenPage extends StatefulWidget {
  const ParentsChildrenPage({super.key});

  @override
  State<ParentsChildrenPage> createState() => _ParentsChildrenPage();
}

class _ParentsChildrenPage extends State<ParentsChildrenPage> {
  int _selectedIndex = 0;
  static List _widgetOptions = ['김자녀', '김막내'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내 자녀 조회'),
          bottom: const TabBar(tabs: [
            Tab(
              child: ChildrenTap(
                name: '첫째',
              ),
            ),
            Tab(
              child: ChildrenTap(
                name: '둘째',
              ),
            ),
            Tab(
              child: ChildrenTap(
                name: '막내',
              ),
            ),
          ]),
        ),
        body: const TabBarView(
          children: [
            //자녀 목록 조회 DATA
            ChildInfo(name: '첫째'),
            ChildInfo(name: '둘째'),
            ChildInfo(name: '막내'),
            // ChildrenTabBar(),
            //자녀 상세 조회

            //미션 목록 조회
          ],
        ),
      ),
    );
  }
}

/*58
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