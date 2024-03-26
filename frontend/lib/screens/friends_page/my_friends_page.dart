import 'package:flutter/material.dart';
import 'package:frontend/screens/profile_page/my_profile_page.dart';
import 'package:frontend/screens/friends_page/widgets/contacts_modal.dart';
import 'package:frontend/screens/friends_page/widgets/friends.dart';
import 'package:get/get.dart';

class MyFriendsPage extends StatefulWidget {
  const MyFriendsPage({super.key});

  @override
  _MyFriendsPageState createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> {
  late List<dynamic> myFriendsList = [];
  List<dynamic> filteredFriendsList = []; // 필터링된 친구 목록을 위한 상태
  TextEditingController searchController = TextEditingController(); // 검색 컨트롤러

  @override
  void initState() {
    super.initState();
    loadFriends();
  }

  Future<void> loadFriends() async {
    var fetchedFriendsList = await fetchFriendsFromAPI();
    setState(() {
      myFriendsList = fetchedFriendsList;
      filteredFriendsList = List.from(fetchedFriendsList); // 초기 값 설정
    });
  }

  void filterFriends(String query) {
    List<dynamic> tempList = [];
    if (query.isNotEmpty) {
      tempList.addAll(myFriendsList.where((friend) =>
          friend['friend_name'].toLowerCase().contains(query.toLowerCase()) ||
          friend['friend_nickname']
              .toLowerCase()
              .contains(query.toLowerCase())));
    } else {
      tempList = List.from(myFriendsList); // 검색어가 비어있으면 모든 친구 목록을 보여줌
    }
    setState(() {
      filteredFriendsList = tempList;
    });
  }

  Future<List<dynamic>> fetchFriendsFromAPI() async {
    // 예시 데이터 반환
    return [
      {
        "friend_id": 1,
        "friend_nickname": '김가영',
        "friend_profileImg":
            'https://i.namu.wiki/i/iWIojn1ABpv6dztK0OCtQ1DeGBX79f2GK7FP-sKzdL8jOmJ5OLamkEyn2B-rmo9GuEdFPCia0TS6bIY7AUtbx2HfG5ZnFscT-P0sc_0Stf92shBJrtq7v-e2F3we-SSO_0RFAlPz26FuMIOffVsRDw.webp',
        "friend_name": "김가영",
        "friend_loginid": 'kky123',
      },
      {
        "friend_id": 2,
        "friend_nickname": '나나',
        "friend_profileImg":
            'https://cdn2.colley.kr/item_88060_1_2_title_2.jpeg',
        "friend_name": '박나린', // 오타 수정: "frined_name" -> "friend_name"
        "friend_loginid": 'narinpark',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 목록'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: filterFriends, // 사용자 입력이 바뀔 때마다 필터링
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 206, 202, 202),
                      border: InputBorder.none,
                      hintText: '이름으로 검색',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return const Dialog(
                    //       child: ContactsModal(),
                    //     );
                    //   },
                    // );
                    Get.to(() => ContactsModal());
                  },
                  icon: const Icon(Icons.person_add),
                  iconSize: 35,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFriendsList.length, // 필터링된 목록 사용
                itemBuilder: (context, index) {
                  var friend = filteredFriendsList[index];
                  return InkWell(
                    onTap: () {
                      // 탭 이벤트 핸들러
                      // 여기에 원하는 작업을 수행하세요. 예: 상세 페이지로 이동
                      print('${friend['friend_name']} 클릭됨');
                      // 예를 들어, 친구 상세 페이지로 네비게이트하는 코드를 추가할 수 있습니다.
                      Get.to(() => const MyProfilePage());
                    },
                    child: Friends(
                      friendLoginId: friend['friend_loginid'],
                      friendName: friend['friend_name'],
                      friendProfileImg: friend['friend_profileImg'],
                      friendNickname: friend['friend_nickname'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
