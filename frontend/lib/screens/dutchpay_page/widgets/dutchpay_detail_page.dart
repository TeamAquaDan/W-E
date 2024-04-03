import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/screens/dutchpay_page/widgets/dutchpay_account_carousel.dart';
import 'package:frontend/screens/dutchpay_page/widgets/dutchpay_my_payment_page.dart';
import 'package:frontend/screens/dutchpay_page/widgets/dutchpay_payment_page.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class DutchPayDetailPage extends StatefulWidget {
  const DutchPayDetailPage(
      {super.key,
      required this.roomId,
      required this.roomName,
      required this.dutchpayDate,
      required this.managerId});

  final int roomId;
  final String roomName;
  final String dutchpayDate;
  final int managerId;

  @override
  _DutchPayDetailPageState createState() => _DutchPayDetailPageState();
}

class _DutchPayDetailPageState extends State<DutchPayDetailPage> {
  late List<dynamic> dutchpayDetail = [];
  late List<dynamic> payments = [];
  final Set<int> _selectedPayments = Set();

  @override
  void initState() {
    super.initState();
    Get.put(AccountController()).fetchAccounts();
    loadRoomDetails();
    loadPayments(); // initState에서 데이터 로딩을 시작합니다.
  }

  void _togglePaymentSelection(int index) {
    setState(() {
      if (_selectedPayments.contains(index)) {
        _selectedPayments.remove(index);
      } else {
        _selectedPayments.add(index);
      }
    });
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
        title: const Text('더치페이'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.roomName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.dutchpayDate,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return PaymentSelectionSheet(
                          payments: payments,
                          selectedPayments: _selectedPayments,
                          paymentDate: widget.dutchpayDate,
                          togglePaymentSelection: _togglePaymentSelection,
                          roomId: widget.roomId,
                        );
                      },
                    );
                    loadRoomDetails();
                  },
                  child: Text(
                    '＋ 내역 추가하기',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: dutchpayDetail.length,
                itemBuilder: (context, index) {
                  var detail = dutchpayDetail[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: detail['_register'] == false
                          ? Color(0xffc9c9c9)
                          : Color(0xff568ef8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: detail['profile_image'] == null
                          ? const CircleAvatar(child: Icon(Icons.person))
                          : CircleAvatar(
                              backgroundImage:
                                  NetworkImage(detail['profile_image'])),
                      title: Text(
                        detail['user_name'],
                        style: TextStyle(
                          color: detail['_register'] == false
                              ? Color(0xff919191)
                              : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${detail['total_amt']} 원',
                        style: TextStyle(
                          color: detail['_register'] == false
                              ? Color(0xff919191)
                              : Colors.white,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (detail['_completed'] == false &&
                                  detail['_login_user'] == true)
                              ? TextButton(
                                  onPressed: () {
                                    final DioService dioService = DioService();
                                    try {
                                      var response = dioService.dio.patch(
                                          '${baseURL}api/dutchpay/self/${detail['dutchpay_id']}',
                                          data: {
                                            'account_num': '010334567890',
                                            'account_password': '7948'
                                          });
                                      print(response);
                                    } catch (err) {
                                      print(err);
                                    }
                                  },
                                  child: const Text('강제정산'))
                              : const SizedBox(width: 0, height: 0),
                          detail['_completed']
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(Icons.close, color: Colors.red),
                        ],
                      ),
                      onTap: () async {
                        final DioService dioService = DioService();
                        try {
                          var response = await dioService.dio.get(
                            '${baseURL}api/dutchpay/payments',
                            data: {
                              'room_id': widget.roomId,
                              'dutchpay_id': detail['dutchpay_id']
                            },
                          );
                          // API 응답 데이터에서 리스트를 추출
                          List<dynamic> items = response.data[
                              'data']; // 'list'는 예시 키입니다. 실제 응답 구조에 따라 변경해야 합니다.

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('응답 데이터 목록'),
                                content: Container(
                                  width: double.maxFinite, // 다이얼로그 너비 최대로 설정
                                  child: ListView.builder(
                                    shrinkWrap:
                                        true, // 다이얼로그 크기에 맞게 ListView 크기 조절
                                    itemCount: items.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // 여기서 items[index]는 한 아이템의 데이터입니다.
                                      // 예제에서는 간단히 문자열로 가정합니다. 실제 데이터 구조에 맞게 조정하세요.
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              Text(items[index]
                                                  ['member_store_name']),
                                              Text(
                                                  '${items[index]['trans_amt']}'),
                                            ],
                                          ), // 'name'은 예시 필드입니다. 실제 필드에 맞게 변경하세요.
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('닫기'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (err) {
                          print(err);
                          // 에러 처리를 위한 다이얼로그 표시
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       title: Text('오류 발생'),
                          //       content: SingleChildScrollView(
                          //         child: ListBody(
                          //           children: <Widget>[
                          //             Text('API 요청 중 오류가 발생했습니다.'),
                          //           ],
                          //         ),
                          //       ),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           child: Text('닫기'),
                          //           onPressed: () {
                          //             Navigator.of(context).pop();
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Get.find<UserController>().getUserId() == widget.managerId
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xff568ef8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('정산하기'),
                              content: const Text('정산을 진행하시겠습니까?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    // "No"를 선택했을 때의 행동
                                    Navigator.of(context).pop(); // 대화상자 닫기
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    // "Yes"를 선택했을 때의 행동
                                    final DioService dioService = DioService();
                                    try {
                                      var response = dioService.dio.patch(
                                          '${baseURL}api/dutchpay/${widget.roomId}');
                                      print(response);
                                    } catch (err) {
                                      print(err);
                                    }
                                    Navigator.of(context).pop(); // 대화상자 닫기
                                    // 정산 로직을 여기에 구현...
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        '정산하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}

class PaymentSelectionSheet extends StatefulWidget {
  final List<dynamic> payments;
  final Set<int> selectedPayments;
  final Function(int) togglePaymentSelection;
  final String paymentDate;
  final int roomId;

  const PaymentSelectionSheet({
    Key? key,
    required this.payments,
    required this.selectedPayments,
    required this.togglePaymentSelection,
    required this.paymentDate,
    required this.roomId,
  }) : super(key: key);

  @override
  _PaymentSelectionSheetState createState() => _PaymentSelectionSheetState();
}

class _PaymentSelectionSheetState extends State<PaymentSelectionSheet> {
  List<Map<String, dynamic>> transactions = [];
  int? _accountId;
  String? _accountPassword;
  String? _accountNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('내역 목록',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text(widget.paymentDate, style: TextStyle(fontSize: 15)),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.payments.length,
              itemBuilder: (BuildContext context, int index) {
                var payment = widget.payments[index];
                bool isSelected = widget.selectedPayments.contains(index);

                return Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xff568ef8) : Color(0xffc9c9c9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payment['member_store_name'].toString(),
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : Color(0xff919191),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${payment['trans_amt'].toString()}원',
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : Color(0xff919191),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        widget.togglePaymentSelection(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff568ef8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    // 기존에 선택된 payments를 기반으로 transactions 리스트 초기화
                    widget.selectedPayments.forEach((index) {
                      var payment = widget.payments[index];
                      transactions.add({
                        'trans_id': payment['trans_id'],
                        'member_store_name': payment['member_store_name'],
                        'trans_amt': payment['trans_amt'],
                        'category': payment['category'],
                      });
                    });
                  });
                  print(transactions);
                  showAccountCarouselDialogDutchPay(
                      context, transactions, widget.roomId);
                },
                child: Text(
                  '선택 완료',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
