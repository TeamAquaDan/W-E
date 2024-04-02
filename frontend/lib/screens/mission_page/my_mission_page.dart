import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/mission_page/widgets/mission.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:frontend/widgets/custom_tab_bar.dart';
import 'package:intl/intl.dart';

class MyMissionPage extends StatefulWidget {
  const MyMissionPage({super.key});

  @override
  State<MyMissionPage> createState() => _MyMissionPageState();
}

class _MyMissionPageState extends State<MyMissionPage> {
  late List<dynamic> missions = []; // 여기에 API 응답 데이터를 저장합니다.
  int selectedTabIndex = 0;

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

  void onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
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
    // 완료된 미션들만 필터링
    List<dynamic> completedMissions = missions
        .where((mission) => mission['status'] == 1 || mission['status'] == 2)
        .toList();
    // 진행 중인 미션들의 총 금액 계산
    int totalOngoingMissionReward = ongoingMissions.fold<int>(0,
        (int sum, dynamic mission) => sum + (mission['mission_reward'] as int));

    // 완료된 미션들의 총 금액 계산
    int totalCompletedMissionReward = completedMissions.fold<int>(
        0,
        (int sum, dynamic mission) =>
            sum +
            (mission['status'] > 0 ? mission['mission_reward'] as int : 0));

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('미션 목록'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomTabBar(
              selectedTabIndex: selectedTabIndex,
              onTabChanged: onTabChanged,
              tabLabels: ['진행 중', '완료 됨'],
            ),
          ),
        ),
        body: selectedTabIndex == 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '미션으로',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '총 ${formatNumber(totalOngoingMissionReward)}원을 얻을 수 있어요!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ongoingMissions.length,
                      itemBuilder: (context, index) {
                        final mission = ongoingMissions[index];
                        return Mission(
                          missionStatus: mission['status'],
                          missionName: mission['mission_name'],
                          missionReward: mission['mission_reward'],
                          deadlineDate: mission['deadline_date'],
                          userName: mission['user_name'],
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '미션으로',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '총 ${formatNumber(totalCompletedMissionReward)}원을 얻었어요!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: completedMissions.length,
                      itemBuilder: (context, index) {
                        final mission = completedMissions[index];
                        return Mission(
                          missionStatus: mission['status'],
                          missionName: mission['mission_name'],
                          missionReward: mission['mission_reward'],
                          deadlineDate: mission['deadline_date'],
                          userName: mission['user_name'],
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
