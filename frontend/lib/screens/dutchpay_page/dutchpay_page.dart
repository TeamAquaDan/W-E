import 'package:flutter/material.dart';
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
          title: const Text('Dutch Pay Page'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Action to perform on button press. You could navigate to a page to create a new room.
                // For example:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRoomPage()));
                Get.to(() => const CreateDutchPayRoom());
              },
              child: const Text('Create a new room'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dutchpayRooms.length,
                itemBuilder: (context, index) {
                  var room = dutchpayRooms[index];
                  return ListTile(
                    leading: const Icon(Icons
                        .room_outlined), // Displays an icon before the title.
                    title: Text(room['room_name']
                        .toString()), // Display the name of the room.

                    // Display the total amount and number of participants below the name.
                    trailing: const Icon(Icons
                        .arrow_forward), // Displays an icon at the end of the ListTile.
                    onTap: () {
                      Get.to(() => DutchPayDetailPage(roomId: room['room_id']));
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
