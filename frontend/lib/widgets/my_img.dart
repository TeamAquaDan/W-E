import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/screens/profile_page/my_profile_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class MyProfileIcon extends StatefulWidget {
  const MyProfileIcon({super.key});

  @override
  State<MyProfileIcon> createState() => _MyProfileIconState();
}

class _MyProfileIconState extends State<MyProfileIcon> {
  var userId = Get.find<UserController>().getUserId();
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
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    final DioService dioService = DioService();

    try {
      final response = await dioService.dio.post(
        '${baseURL}api/user/profile',
        data: {
          'user_id': userId,
        },
      );
      if (response.statusCode == 200) {
        print('POST request 성공: ${response.data}');
        return [response.data['data']];
      } else {
        print('POST request 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: 에러 $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyProfilePage(userId: userId)),
        );
      },
      child: CircleAvatar(
        child: ClipOval(
          child: Image.network(
            myProfileList[0]['profile_img'] ??
                'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbyfdKI%2FbtsGbRH96Xy%2FH3KbM1y85UhvkGtKT3KWu0%2Fimg.png',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
