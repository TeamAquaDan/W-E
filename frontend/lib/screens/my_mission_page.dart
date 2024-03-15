import 'package:flutter/material.dart';
import 'package:frontend/widgets/mission.dart';

class MyMissionPage extends StatefulWidget {
  const MyMissionPage({super.key});

  @override
  State<MyMissionPage> createState() => _MyMissionPageState();
}

class _MyMissionPageState extends State<MyMissionPage> {
  late List<dynamic> missions; // 여기에 API 응답 데이터를 저장합니다.

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
    // 이 함수는 실제 API 요청 로직을 구현해야 합니다.
    // 임시로 빈 리스트를 반환하도록 설정합니다.
    return [
      {
        "mission_id": 635,
        "mission_name": "사진 촬영 새 제품",
        "mission_reward": 81100,
        "deadline_date": "2024-03-28 07:36:20",
        "status": 1,
        "user_name": "정예진"
      },
      {
        "mission_id": 534,
        "mission_name": "설문 참여 음식점",
        "mission_reward": 99623,
        "deadline_date": "2024-04-09 07:36:20",
        "status": 1,
        "user_name": "이서연"
      },
      {
        "mission_id": 88,
        "mission_name": "리뷰 작성 새 제품",
        "mission_reward": 58258,
        "deadline_date": "2024-04-13 07:36:20",
        "status": 0,
        "user_name": "이예진"
      },
      {
        "mission_id": 593,
        "mission_name": "사진 촬영 앱",
        "mission_reward": 58413,
        "deadline_date": "2024-03-30 07:36:20",
        "status": 0,
        "user_name": "김민준"
      },
      {
        "mission_id": 645,
        "mission_name": "동영상 시청 새 제품",
        "mission_reward": 82355,
        "deadline_date": "2024-03-17 07:36:20",
        "status": 0,
        "user_name": "정지아"
      },
      {
        "mission_id": 975,
        "mission_name": "리뷰 작성 서비스",
        "mission_reward": 74259,
        "deadline_date": "2024-03-19 07:36:20",
        "status": 1,
        "user_name": "박예진"
      },
      {
        "mission_id": 570,
        "mission_name": "리뷰 작성 영화",
        "mission_reward": 39895,
        "deadline_date": "2024-04-12 07:36:20",
        "status": 0,
        "user_name": "김서연"
      },
      {
        "mission_id": 24,
        "mission_name": "설문 참여 영화",
        "mission_reward": 18670,
        "deadline_date": "2024-03-23 07:36:20",
        "status": 2,
        "user_name": "김민준"
      },
      {
        "mission_id": 929,
        "mission_name": "리뷰 작성 음식점",
        "mission_reward": 6332,
        "deadline_date": "2024-03-29 07:36:20",
        "status": 0,
        "user_name": "김서연"
      },
      {
        "mission_id": 172,
        "mission_name": "데이터 입력 음식점",
        "mission_reward": 89635,
        "deadline_date": "2024-04-02 07:36:20",
        "status": 0,
        "user_name": "최서연"
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // 액션 추가
            },
          ),
          title: Text('미션 목록'),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Text('진행 중'),
              ),
              Tab(
                child: Text('완료 됨'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: [Mission()],
              ),
            ),
            Center(child: Text('두 번째 탭')),
          ],
        ),
      ),
    );
  }
}
