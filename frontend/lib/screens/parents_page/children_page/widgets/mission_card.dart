import 'package:flutter/material.dart';
import 'package:frontend/models/mission_data.dart';
import 'package:intl/intl.dart';

class MissionCard extends StatelessWidget {
  // const MissionCard(
  //     {super.key,
  //     required this.title,
  //     required this.money,
  //     required this.deadline});
  // final String title;
  // final int money;
  // final String deadline;
  const MissionCard(this.missionData, {super.key});
  final MissionData missionData;

  @override
  Widget build(BuildContext context) {
    var moneyFormat = NumberFormat('###,###,###,### 원');

    return Card(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: const Color(0xFF7A97FF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      missionData.mission_name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      missionData.deadline_date,
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      moneyFormat.format(missionData.mission_reward),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // 미션 관리 36
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 131, 220, 183),
                          ),
                          child: const Text(
                            '성공',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 220, 131, 131),
                          ),
                          child: const Text(
                            '실패',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
"{
  ""group_id"": 'int, 그룹 아이디
  ""mission_id"": ""int, 미션 아이디""
  ""status"": ""int, 처리상태""
}

1(미션 성공 시), 2(미션 실패 시)"


"{
  ""status"": 200, 
  ""message"": ""미션 조회 성공"", 
  ""data"": {
     ""mission_name"": ""string, 미션 제목"",
     ""mission_reward"": ""int, 보상금액"", 
     ""deadline_date"": ""string, 마감 일시"",
     ""status"": ""int, 처리 상태"",
     ""user_name"" : ""string, 미션 제공자 이름""
  }
}
처리상태 0(진행중), 1(성공), 2(실패)"
*/