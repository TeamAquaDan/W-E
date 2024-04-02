import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/base_profile_url.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:intl/intl.dart';

Future postDutchPayRoom(
    {required String roomName,
    required String dutchpayDate,
    required List<int> members}) async {
  final DioService dioService = DioService();
  try {
    Map<String, dynamic> body = {
      "room_name": roomName,
      "dutchpay_date": dutchpayDate,
      "members": members,
    };
    dio.Response response =
        await dioService.dio.post('${baseURL}api/dutchpay', data: body);
// body : "{
//   ""room_name"": ""string, 방 제목"",
//   ""dutchpay_date"": ""string, 결제 일자"",
//   ""members"" : [ ""int, user_id, 초대할 친구 아이디"" ]
// }"
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
// response.data : "{
//   ""status"": 200,
//   ""message"": ""더치페이 방 생성 성공"",
//   ""data"": {
//      ""room_id"": ""int, 방 아이디"",
//      ""dutchpay_date"": ""string, 결제 일자 YYYY-mm-dd"",
//      ""manager_id"": ""int, 방장"",
//      ""is_completed"": ""boolean, 완료 여부"",
//      ""member_num"" : int, 총 인원 수,
//      ""members"" : [
//              ""profile_img"": ""string, 친구 프로필사진""
//           ]
//   }
// }"
    return response.data;
  } catch (error) {
    print('Error sending POST request: $error');
  }
}

Future<List<dynamic>> getFriends() async {
  DioService dioService = DioService();
  try {
    var response = await dioService.dio.get('${baseURL}api/friend');
    print(response.data['data']);
    return response.data['data']; // API로부터 받은 데이터를 반환합니다.
  } catch (err) {
    print(err);
    return []; // 에러가 발생한 경우 빈 리스트를 반환합니다.
  }

  // 예시 데이터 반환
  // return [
  //   {
  //     "friend_id": 1,
  //     "friend_nickname": '김가영',
  //     "friend_profileImg":
  //         'https://i.namu.wiki/i/iWIojn1ABpv6dztK0OCtQ1DeGBX79f2GK7FP-sKzdL8jOmJ5OLamkEyn2B-rmo9GuEdFPCia0TS6bIY7AUtbx2HfG5ZnFscT-P0sc_0Stf92shBJrtq7v-e2F3we-SSO_0RFAlPz26FuMIOffVsRDw.webp',
  //     "friend_name": "김가영",
  //     "friend_loginid": 'kky123',
  //   },
  //   {
  //     "friend_id": 2,
  //     "friend_nickname": '나나',
  //     "friend_profileImg":
  //         'https://cdn2.colley.kr/item_88060_1_2_title_2.jpeg',
  //     "friend_name": '박나린',
  //     "friend_loginid": 'narinpark',
  //   }
  // ];
}

class CreateDutchPayRoom extends StatefulWidget {
  const CreateDutchPayRoom({super.key});

  @override
  _CreateDutchPayRoomState createState() => _CreateDutchPayRoomState();
}

class _CreateDutchPayRoomState extends State<CreateDutchPayRoom> {
  final _formKey = GlobalKey<FormState>();
  String roomName = '';
  DateTime? dutchpayDate;
  String dutchpayDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<int> members = [];
  Future<List<dynamic>> friendsFuture = getFriends();
  List<dynamic> filteredFriends = []; // 여기에 필터링된 친구들의 정보를 저장합니다.

  void updateMembers(List<int> newMembers) {
    setState(() {
      members = newMembers;
      updateFilteredFriends();
    });
  }

  void updateFilteredFriends() async {
    final friends = await getFriends();
    setState(() {
      filteredFriends = friends
          .where((friend) => members.contains(friend["friend_id"]))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('더치페이 방 만들기'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '방 이름',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff999999),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '방 이름을 입력해주세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  roomName = value!;
                },
              ),
              const SizedBox(height: 16),
              Text(
                '날짜 선택',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff999999),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
                readOnly: true, // This will prohibit manual editing
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime.now());
                  if (date != null) {
                    setState(() {
                      dutchpayDate = date;
                      dutchpayDateString =
                          DateFormat('yyyy-MM-dd').format(date);
                    });
                  }
                },
                controller: TextEditingController(text: dutchpayDateString),
              ),
              const SizedBox(height: 16),
              Text(
                '함께한 친구',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff999999),
                ),
              ),
              Center(
                child: TextButton(
                  child: Text(
                    '＋ 친구 추가하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff568EF8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      members = [];
                    });
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return MyCheckboxList(
                          friendsFuture: friendsFuture,
                          members: members,
                          onMembersChanged: updateMembers,
                        );
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = filteredFriends[index];
                    final friendId = friend["friend_id"];

                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 8), // 간격 조정
                      decoration: BoxDecoration(
                        color: Color(0xff568ef8),
                        borderRadius: BorderRadius.circular(15), // 둥근 모서리 추가
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              friend["friend_profileImg"] ??
                                  '${baseProfileURL}'),
                        ),
                        title: Row(
                          children: [
                            SizedBox(width: 40),
                            Text(
                              '${friend["friend_nickname"]} (${friend['friend_name']})',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff568EF8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '방 만들기',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCheckboxList extends StatefulWidget {
  final Future<List<dynamic>> friendsFuture;
  final List<int> members;
  final ValueChanged<List<int>> onMembersChanged;

  const MyCheckboxList({
    super.key,
    required this.friendsFuture,
    required this.members,
    required this.onMembersChanged,
  });

  @override
  _MyCheckboxListState createState() => _MyCheckboxListState();
}

class _MyCheckboxListState extends State<MyCheckboxList> {
  late Future<List<dynamic>> _friendsFuture;
  Map<int, bool> _selectedFriends = {};

  @override
  void initState() {
    super.initState();
    _friendsFuture = widget.friendsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _friendsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> friends = snapshot.data ?? [];
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ), // ListView 전체에 패딩 적용
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '친구 목록',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friendId = friends[index]["friend_id"];
                    final isSelected = _selectedFriends[friendId] ?? false;

                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin:
                          const EdgeInsets.only(bottom: 8), // 여기서 간격을 조정합니다.
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xff568ef8) : Color(0xffC9C9C9),
                        borderRadius:
                            BorderRadius.circular(15), // 선택적으로 둥근 모서리 추가
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(friends[index]
                                  ["friend_profileImg"] ??
                              '${baseProfileURL}'),
                        ),
                        title: Row(
                          children: [
                            SizedBox(width: 40),
                            Text(
                              '${friends[index]["friend_nickname"]} (${friends[index]['friend_name']})',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xff919191),
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            // 선택 상태 토글
                            _selectedFriends[friendId] = !isSelected;
                            if (_selectedFriends[friendId] == true) {
                              widget.members.add(friendId);
                            } else {
                              widget.members.remove(friendId);
                            }
                            widget.onMembersChanged(widget.members);
                          });
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff568EF8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '선택 완료',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
