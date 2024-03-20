import 'package:flutter/material.dart';
import 'package:frontend/screens/my_friends_page.dart';
import 'package:get/get.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late List<dynamic> myProfileList = [];

  @override
  void initState() {
    super.initState();
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetcedProfile = await fetchProfilesFromAPI();
    setState(() {
      myProfileList = fetcedProfile; // API로부터 받아온 데이터를 상태에 저장합니다.
    });
  }

  Future<List<dynamic>> fetchProfilesFromAPI() async {
    return [
      {
        'user_id': 1,
        'login_id': 'chunsik',
        'username': '춘식이',
        'profile_img':
            'https://i.namu.wiki/i/D95WsY8MeICt3KVX1_tUf7KOIexMwiNeNvWtPFpVxez2l8PZd9ULpEiTCcYtfWLi7oo5e2He6YjyvHdWypIr4deeOgSkUfU_LTxDT-BUFOeHD65eCe36Bzn58ik-gMENFo7xgrDWyNEboaH8wpwShQ.webp',
        'birthdate': '2002.06.20',
        'editable': true,
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 프로필'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 컨텐츠를 위에서부터 시작하도록 설정
          children: [
            SizedBox(height: 30), // 상단 여백
            Container(
              width: 94,
              height: 94,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://i.namu.wiki/i/D95WsY8MeICt3KVX1_tUf7KOIexMwiNeNvWtPFpVxez2l8PZd9ULpEiTCcYtfWLi7oo5e2He6YjyvHdWypIr4deeOgSkUfU_LTxDT-BUFOeHD65eCe36Bzn58ik-gMENFo7xgrDWyNEboaH8wpwShQ.webp'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(50), // 원형 이미지로 만들기
              ),
            ),
            SizedBox(height: 12),
            Text(
              myProfileList[0]['username'],
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3), // 프로필 이름과 아이디 사이의 여백
            Text(
              '@${myProfileList[0]['login_id']}',
              style: TextStyle(
                color: Colors.black, // 색상 코드 수정
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF6750A4),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    // 내친구관리 버튼 액션
                    Get.to(() => MyFriendsPage());
                  },
                  child: Text(
                    '내친구관리',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: Color(0xFF6750A4),
                  ),
                  onPressed: () {
                    // 프로필수정 버튼 액션
                  },
                  child: Text(
                    '프로필수정',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // 버튼과 하단 여백
            // 필요한 경우 여기에 추가적인 위젯 배치
          ],
        ),
      ),
    );
  }
}
