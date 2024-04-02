import 'package:flutter/material.dart';
import 'package:frontend/api/base_profile_url.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/dutchpay_page/widgets/create_room.dart';
import 'package:frontend/screens/dutchpay_page/widgets/dutchpay_detail_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class DutchPayPage extends StatefulWidget {
  const DutchPayPage({super.key});

  @override
  _DutchPayPageState createState() => _DutchPayPageState();
}

class _DutchPayPageState extends State<DutchPayPage> {
  late List<dynamic> dutchpayRooms = [];

  @override
  void initState() {
    super.initState();
    loadRooms(); // initState에서 데이터 로딩을 시작합니다.
  }

  Future<void> loadRooms() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedRooms = await fetchRoomsFromAPI();
    setState(() {
      dutchpayRooms = fetchedRooms; // API로부터 받아온 데이터를 상태에 저장합니다.
    });
  }

  Future<List<dynamic>> fetchRoomsFromAPI() async {
    final DioService dioService = DioService();
    try {
      var response = await dioService.dio.get('${baseURL}api/dutchpay');
      print(response.data['data']);
      return response.data['data'];
    } catch (err) {
      print(err);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('더치페이'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dutchpayRooms.length + 1,
                itemBuilder: (context, index) {
                  if (index < dutchpayRooms.length) {
                    var room = dutchpayRooms[index];
                    List<String> profileImages =
                        (room['profile_img'] as List<dynamic>? ?? [])
                            .map((imgUrl) =>
                                imgUrl as String? ?? '${baseProfileURL}')
                            .toList();

                    return GestureDetector(
                      onTap: () {
                        // Place your navigation or action here
                        Get.to(
                            () => DutchPayDetailPage(roomId: room['room_id']));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8), // 카드 주변의 여백을 설정합니다.
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff568EF8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 26),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${room['room_name']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${room['dutchpay_date'].toString().replaceAll('-', '.')}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 60, // Set a fixed height for the Stack
                                child: Stack(
                                  children: profileImages.map((imgUrl) {
                                    int index = profileImages.indexOf(imgUrl);
                                    return Positioned(
                                      right: 30.0 *
                                          index, // This will give a cascading effect
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            imgUrl == null
                                                ? '${baseProfileURL}'
                                                : imgUrl),
                                        radius:
                                            25, // Adjust the size of each avatar
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff568EF8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 22, horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              '더치페이 시작하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 15),
                            IconButton(
                              onPressed: () {
                                Get.to(() => const CreateDutchPayRoom());
                              },
                              icon: const Icon(Icons.add_circle_rounded),
                              color: Color(0xff1051CE),
                              iconSize: 55,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
