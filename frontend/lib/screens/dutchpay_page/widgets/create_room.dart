import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
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
  void updateMembers(List<int> newMembers) {
    setState(() {
      members = newMembers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('더치페이 방 생성'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: '방 이름'),
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
            TextFormField(
              decoration: const InputDecoration(labelText: '더치페이 할 날짜'),
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
                    dutchpayDateString = DateFormat('yyyy-MM-dd').format(date);
                  });
                }
              },
              controller: TextEditingController(text: dutchpayDateString),
            ),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
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
            Text(members.toString()),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  postDutchPayRoom(
                      roomName: roomName,
                      dutchpayDate: dutchpayDateString,
                      members: members);
                }
              },
              child: const Text('방 생성'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckboxList extends StatefulWidget {
  final Future<List<dynamic>> friendsFuture;
  final List<int> members;
  final ValueChanged<List<int>> onMembersChanged;
  const MyCheckboxList(
      {super.key, required this.friendsFuture,
      required this.members,
      required this.onMembersChanged});

  @override
  _MyCheckboxListState createState() => _MyCheckboxListState();
}

class _MyCheckboxListState extends State<MyCheckboxList> {
  late Future<List<dynamic>> _friendsFuture;
  Map<int, bool> checkboxStates = {};

  @override
  void initState() {
    super.initState();
    _friendsFuture = widget.friendsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _friendsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> friends = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: friends.length,
            itemBuilder: (context, index) {
              int friendId = friends[index]["friend_id"];
              if (!checkboxStates.containsKey(friendId)) {
                checkboxStates[friendId] = false;
              }

              return CheckboxListTile(
                title: Text(friends[index]["friend_nickname"]),
                value: checkboxStates[friendId],
                onChanged: (bool? value) {
                  setState(() {
                    checkboxStates[friendId] = value!;
                    if (value == true) {
                      if (!widget.members.contains(friendId)) {
                        widget.members.add(friendId);
                      }
                    } else {
                      widget.members.remove(friendId);
                    }
                    widget.onMembersChanged(widget.members);
                  });
                },
              );
            },
          );
        }
      },
    );
  }
}
