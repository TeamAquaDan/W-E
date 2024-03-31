import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/dutchpay_page/widgets/dutchpay_my_payment_page.dart';
import 'package:frontend/screens/dutchpay_page/widgets/dutchpay_payment_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class DutchPayDetailPage extends StatefulWidget {
  const DutchPayDetailPage({super.key, required this.roomId});

  final int roomId;

  @override
  _DutchPayDetailPageState createState() => _DutchPayDetailPageState();
}

class _DutchPayDetailPageState extends State<DutchPayDetailPage> {
  late List<dynamic> dutchpayDetail = [];

  @override
  void initState() {
    super.initState();
    loadRoomDetails(); // initState에서 데이터 로딩을 시작합니다.
  }

  Future<void> loadRoomDetails() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedRoomDetails = await fetchRoomDetailsFromAPI();
    setState(() {
      dutchpayDetail = fetchedRoomDetails; // API로부터 받아온 데이터를 상태에 저장합니다.
      dutchpayDetail.sort((a, b) =>
          (b['_login_user'] ? 1 : 0).compareTo(a['_login_user'] ? 1 : 0));
    });
  }

  Future<List<dynamic>> fetchRoomDetailsFromAPI() async {
    final DioService dioService = DioService();
    try {
      var response =
          await dioService.dio.get('${baseURL}api/dutchpay/${widget.roomId}');
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
        title: const Text('Dutch Pay Detail Page'),
      ),
      body: ListView.builder(
        itemCount: dutchpayDetail.length,
        itemBuilder: (context, index) {
          var detail = dutchpayDetail[index];
          return ListTile(
            leading: detail['profile_image'] == null
                ? const CircleAvatar(child: Icon(Icons.person))
                : CircleAvatar(
                    backgroundImage: NetworkImage(detail['profile_image'])),
            title: Text(detail['user_name']),
            subtitle: Text('Total Amount: ${detail['total_amt']}'),
            trailing: detail['_completed']
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.close, color: Colors.red),
            tileColor: detail['_login_user']
                ? Colors.lightBlue.shade100
                : null, // _login_user가 true면 배경색을 달리함
            onTap: () {
              if (detail['_login_user']) {
                Get.to(() => DutchPayMyPaymentPage(
                      roomId: widget.roomId,
                    ));
              } else {
                Get.to(() => DutchPayPaymentPage(
                      roomId: widget.roomId,
                      dutchpayId: detail['dutchpay_id'],
                    ));
              }
            },
          );
        },
      ),
    );
  }
}
