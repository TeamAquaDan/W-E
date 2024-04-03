import 'package:flutter/material.dart';
import 'package:frontend/api/base_profile_url.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/profile_page/my_profile_page.dart';
import 'package:frontend/screens/friends_page/widgets/contacts_modal.dart';
import 'package:frontend/screens/friends_page/widgets/friends.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class MyFriendsPage extends StatefulWidget {
  const MyFriendsPage({super.key});

  @override
  _MyFriendsPageState createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> {
  late List<dynamic> myFriendsList = [];
  List<dynamic> filteredFriendsList = []; // 필터링된 친구 목록을 위한 상태
  List<dynamic> requstedFriendsList = []; // 친구 요청 목록을 위한 상태
  bool isPanelExpanded = false;
  TextEditingController searchController = TextEditingController(); // 검색 컨트롤러

  @override
  void initState() {
    super.initState();
    loadFriends();
    loadPendingFriendRequests();
  }

  Future<void> loadPendingFriendRequests() async {
    final DioService dioService = DioService();
    try {
      var response =
          await dioService.dio.get('${baseURL}api/friend/pending-requests');
      print(response.data['data']);
      setState(() {
        requstedFriendsList = response.data['data'];
        // 패널 상태 변경은 이 함수 내에서 직접 하지 않음
      });
    } catch (err) {
      print(err);
    }
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
    DioService dioService = DioService();
    try {
      var response = await dioService.dio.get('${baseURL}api/friend');
      print(response.data['data']);
      return response.data['data']; // API로부터 받은 데이터를 반환합니다.
    } catch (err) {
      print(err);
      return []; // 에러가 발생한 경우 빈 리스트를 반환합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 목록'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadFriends();
        },
        child: Padding(
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
                        fillColor: const Color(0xFFF8F8F8),
                        border: InputBorder.none,
                        hintText: '이름으로 검색',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 0.5),
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
                      Get.to(() => const ContactsModal());
                    },
                    icon: const Icon(Icons.person_add),
                    iconSize: 35,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: isPanelExpanded == true
                      ? const BorderRadius.vertical(top: Radius.circular(10))
                      : BorderRadius.circular(10),
                  color: requstedFriendsList.isEmpty
                      ? const Color(0xFFc9c9c9)
                      : const Color(0xFF568EF8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "새로운 친구 요청",
                      style: TextStyle(
                        color: requstedFriendsList.isEmpty
                            ? const Color(0xFF3c3c3c)
                            : const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    requstedFriendsList.isEmpty
                        ? IconButton(
                            icon: const Icon(Icons.expand_more),
                            color: const Color(0xFF3c3c3c),
                            onPressed: () {},
                          )
                        : IconButton(
                            icon: Icon(isPanelExpanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () async {
                              await loadPendingFriendRequests();
                              setState(() {
                                isPanelExpanded = !isPanelExpanded; // 패널 상태 토글
                              });
                            },
                          ),
                  ],
                ),
              ),
              Visibility(
                visible: isPanelExpanded, // 패널 확장 상태에 따라 보이기/숨기기
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF568EF8),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    width: double.infinity,
                    child: requstedFriendsList.isEmpty == false
                        ? ListView.builder(
                            itemCount: requstedFriendsList.length,
                            shrinkWrap: true, // 리스트의 높이를 내용물에 맞추도록 설정
                            physics:
                                const NeverScrollableScrollPhysics(), // 스크롤이 발생하지 않도록 설정
                            itemBuilder: (context, index) {
                              var request = requstedFriendsList[index];
                              return Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: Colors.white,
                                    title: Text(
                                        '${request['friend_name']} (${request['friend_loginId']})'), // '??' 연산자는 null 체크를 위해 사용됩니다.
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFD9D9D9),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            '거절',
                                            style: TextStyle(
                                                color: Color(0xFF3c3c3c),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          onPressed: () async {
                                            final DioService dioService =
                                                DioService();
                                            try {
                                              // 친구 요청 거절 로직
                                              var response =
                                                  await dioService.dio.post(
                                                '${baseURL}api/friend/manage',
                                                data: {
                                                  'user_id':
                                                      request['friend_id'],
                                                  'status': 2 // 가정: '2'가 거절을 의미
                                                },
                                              );
                                              if (response.statusCode == 200) {
                                                // API 호출 성공
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('친구 요청을 거절했습니다.'),
                                                ));
                                                await loadFriends(); // 친구 목록 다시 로드
                                                await loadPendingFriendRequests();
                                              } else {
                                                // API 호출 실패
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('친구 요청 거절에 실패했습니다.'),
                                                ));
                                              }
                                            } catch (e) {
                                              // 예외 처리
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text('오류가 발생했습니다: $e'),
                                              ));
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 5),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF568EF8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            '수락',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          onPressed: () async {
                                            final DioService dioService =
                                                DioService();
                                            try {
                                              // 친구 요청 수락 로직
                                              var response =
                                                  await dioService.dio.post(
                                                '${baseURL}api/friend/manage',
                                                data: {
                                                  'user_id':
                                                      request['friend_id'],
                                                  'status': 1 // 가정: '1'이 수락을 의미
                                                },
                                              );
                                              if (response.statusCode == 200) {
                                                // API 호출 성공
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('친구 요청을 수락했습니다.'),
                                                ));
                                                await loadPendingFriendRequests();
                                                await loadFriends(); // 친구 목록 다시 로드
                                              } else {
                                                // API 호출 실패
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('친구 요청 수락에 실패했습니다.'),
                                                ));
                                              }
                                            } catch (e) {
                                              // 예외 처리
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text('오류가 발생했습니다: $e'),
                                              ));
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : null),
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
                        Get.to(
                            () => MyProfilePage(userId: friend['friend_id']));
                      },
                      child: Friends(
                        friendId: friend['friend_id'],
                        friendLoginId: friend['friend_loginid'],
                        friendName: friend['friend_name'],
                        friendProfileImg:
                            friend['friend_profileImg'] ?? '${baseProfileURL}',
                        friendNickname:
                            friend['friend_nickname'] ?? friend['friend_name'],
                        loadFriendsCallback: loadFriends,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
