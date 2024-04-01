import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/services/dio_service.dart';

class DutchPayPaymentPage extends StatefulWidget {
  const DutchPayPaymentPage(
      {super.key, required this.roomId, required this.dutchpayId});

  final int roomId;
  final int dutchpayId;

  @override
  _DutchPayPaymentPageState createState() => _DutchPayPaymentPageState();
}

class _DutchPayPaymentPageState extends State<DutchPayPaymentPage> {
  late List<dynamic> payments = [];

  @override
  void initState() {
    super.initState();
    loadPayments(); // initState에서 데이터 로딩을 시작합니다.
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
        '${baseURL}api/dutchpay/payments',
        data: {'room_id': widget.roomId, 'dutchpay_id': widget.dutchpayId},
      );
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
        title: Text('My Payments'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showMyPaymentsDialog(),
          child: Text('Show My Payments'),
        ),
      ),
    );
  }

  void showMyPaymentsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('My Payments'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: payments.length,
              itemBuilder: (BuildContext context, int index) {
                var payment = payments[index];
                return ListTile(
                  title: Text('${payment['member_store_name'].toString()}'),
                  subtitle: Text('${payment['trans_amt'].toString()}원'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
