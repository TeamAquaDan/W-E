import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:frontend/screens/saving_goal_page/widgets/saving_goal_account_carousel.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class DutchPayMyPaymentPage extends StatefulWidget {
  const DutchPayMyPaymentPage({super.key, required this.roomId});

  final int roomId;

  @override
  _DutchPayMyPaymentPageState createState() => _DutchPayMyPaymentPageState();
}

class _DutchPayMyPaymentPageState extends State<DutchPayMyPaymentPage> {
  late List<dynamic> payments = [];
  int? _accountId;
  String? _accountName;
  String? _accountNum;

  @override
  void initState() {
    super.initState();
    loadPayments(); // initState에서 데이터 로딩을 시작합니다.
    Get.put(AccountController()).fetchAccounts();
  }

  Future<void> loadPayments() async {
    // 여기에 REST API 요청을 수행하는 코드를 작성합니다.
    // 예시로, 다음은 가상의 데이터 로딩 함수입니다.
    var fetchedPayments = await fetchPaymentsFromAPI();
    setState(() {
      payments = fetchedPayments; // API로부터 받아온 데이터를 상태에 저장합니다.
    });
  }

  Future<List<dynamic>> fetchPaymentsFromAPI() async {
    final DioService dioService = DioService();
    try {
      var response = await dioService.dio.post(
          '${baseURL}api/dutchpay/my-payments',
          data: {'room_id': widget.roomId});
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
        title: const Text('My Payments'),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: payments.length,
            itemBuilder: (BuildContext context, int index) {
              var payment = payments[index];
              return ListTile(
                title: Text(payment['member_store_name'].toString()),
                subtitle: Text('${payment['trans_amt'].toString()}원'),
                onTap: () {
                  confirmPaymentDialog(context, payment);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // void showMyPaymentsDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('My Payments'),
  //         content: Container(
  //           width: double.maxFinite,
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: payments.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               var payment = payments[index];
  //               return ListTile(
  //                 title: Text('${payment['member_store_name'].toString()}'),
  //                 subtitle: Text('${payment['trans_amt'].toString()}원'),
  //                 onTap: () {
  //                   confirmPaymentDialog(context, payment);
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // 사용자 결정을 묻는 대화상자를 표시하는 함수
  void confirmPaymentDialog(BuildContext context, dynamic payment) {
    TextEditingController textFieldController =
        TextEditingController(); // 입력을 관리할 TextEditingController

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('결제 정보 입력'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  showAccountCarouselDialog(context, (String accountId,
                      String accountName, String accountNum) {
                    setState(() {
                      _accountId = int.parse(accountId);
                      _accountName = accountName;
                      _accountNum = accountNum;
                      print('통장 정보 저장');
                    });
                  });
                },
                child: const Text('통장 선택'),
              ),
              _accountName == null
                  ? const Text('통장을 선택해주세요.')
                  : Text('선택된 통장: $_accountName'),
              TextField(
                keyboardType: TextInputType.number,
                controller: textFieldController, // TextField에 컨트롤러 연결
                decoration: const InputDecoration(hintText: "통장 비밀번호"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 대화상자를 닫습니다.
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // 입력된 값을 가져와서 처리합니다. 예를 들어, API 호출에 사용
                String verificationCode = textFieldController.text;
                // 여기서 verificationCode와 함께 결제를 진행할 수 있습니다.
                performPayment(verificationCode, payment); // 수정된 함수 호출
                Navigator.of(context).pop(); // 대화상자를 닫습니다.
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

// performPayment 함수에 verificationCode 매개변수 추가
  Future<void> performPayment(String verificationCode, dynamic payment) async {
    try {
      final DioService dioService = DioService();
      var response = await dioService.dio.post(
        '${baseURL}api/dutchpay/register',
        data: {
          'room_id': widget.roomId,
          'account_id': _accountId,
          'account_num': _accountNum,
          'password': verificationCode,
          'transactions': [
            {
              'trans_id': payment['trans_id'],
              'member_store_name': payment['member_store_name'],
              'trans_amt': payment['trans_amt'],
              'category': payment['category'],
            }
          ]
        },
      );
      print('Payment Successful: ${response.data}');
    } catch (err) {
      print('Error performing payment: $err');
    }
  }
}
