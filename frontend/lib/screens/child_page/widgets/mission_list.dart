import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/mission_page/widgets/mission.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:intl/intl.dart';

class MyMissionList extends StatefulWidget {
  const MyMissionList({super.key});

  @override
  State<MyMissionList> createState() => _MyMissionListState();
}

class _MyMissionListState extends State<MyMissionList> {
  late List<dynamic> missions = []; // 여기에 API 응답 데이터를 저장합니다.

  @override
  void initState() {
    super.initState();
    loadMissions(); // initState에서 데이터 로딩을 시작합니다.
  }

  Future<void> loadMissions() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedMissions = await fetchMissionsFromAPI();
    setState(() {
      missions = fetchedMissions; // API로부터 받아온 데이터를 상태에 저장합니다.
    });
  }

  Future<List<dynamic>> fetchMissionsFromAPI() async {
    final DioService dioService = DioService();
    try {
      var response = await dioService.dio.get('${baseURL}api/mission/search');
      print(response.data['data']);
      return response.data['data'];
    } catch (err) {
      print(err);
      return [];
    }
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    // 진행 중인 미션들만 필터링
    List<dynamic> ongoingMissions =
        missions.where((mission) => mission['status'] == 0).toList();

    return Column(
      children: [
        for (var i = 0; i < ongoingMissions.length; i++)
          Mission(
            missionStatus: ongoingMissions[i]['status'],
            missionName: ongoingMissions[i]['mission_name'],
            missionReward: ongoingMissions[i]['mission_reward'],
            deadlineDate: ongoingMissions[i]['deadline_date'],
            userName: ongoingMissions[i]['user_name'],
          ),
      ],
    );
  }
}
