import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/mission/mission_model.dart';
import 'package:frontend/screens/child_page/widgets/child_mission_card.dart';
import 'package:frontend/screens/mission_page/widgets/mission.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:intl/intl.dart';

class MyMissionList extends StatefulWidget {
  const MyMissionList({super.key});

  @override
  State<MyMissionList> createState() => _MyMissionListState();
}

class _MyMissionListState extends State<MyMissionList> {
  late List<MissionModel> missions = []; // 여기에 API 응답 데이터를 저장합니다.

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

  // Future<List<dynamic>> fetchMissionsFromAPI() async {
  //   final DioService dioService = DioService();
  //   try {
  //     var response = await dioService.dio.get('${baseURL}api/mission/search');
  //     print(response.data['data']);
  //     return response.data['data'];
  //   } catch (err) {
  //     print(err);
  //     return [];
  //   }
  // }
  Future<List<MissionModel>> fetchMissionsFromAPI() async {
    final DioService dioService = DioService();
    try {
      var response = await dioService.dio.get('${baseURL}api/mission/search');
      print(response.data['data']);
      if (response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((mission) => MissionModel.fromJson(mission))
            .toList();
      }
      return [];
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
    // List<dynamic> ongoingMissions =
    //     missions.where((mission) => mission['status'] == 0).toList();
    missions.sort((a, b) {
      // status가 0인 것들을 위로 정렬하도록 비교 함수 작성
      if (a.status == 0 && b.status != 0) {
        return -1; // a가 0이고 b가 0이 아닌 경우 a를 먼저 위치하도록 함
      } else if (a.status != 0 && b.status == 0) {
        return 1; // b가 0이고 a가 0이 아닌 경우 b를 먼저 위치하도록 함
      } else {
        return 0; // 그 외의 경우에는 순서를 변경하지 않음
      }
    });
    return Column(
      children: [
        // for (var i = 0; i < ongoingMissions.length; i++)
        //   Mission(
        //     missionStatus: ongoingMissions[i]['status'],
        //     missionName: ongoingMissions[i]['mission_name'],
        //     missionReward: ongoingMissions[i]['mission_reward'],
        //     deadlineDate: ongoingMissions[i]['deadline_date'],
        //     userName: ongoingMissions[i]['user_name'],
        //   ),
        Column(
          children: missions.map((mission) {
            return ChildMissionCard(
              mission: mission,
            );
          }).toList(),
        ),
      ],
    );
  }
}
