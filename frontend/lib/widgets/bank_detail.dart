import 'package:flutter/material.dart';
import 'package:frontend/api/account/account_list_api.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_top_container.dart';

class BankDetail extends StatefulWidget {
  const BankDetail({super.key, required this.bankData});
  final AccountListData bankData;
  @override
  State<StatefulWidget> createState() {
    return _BankDetailState();
  }
}

class _BankDetailState extends State<BankDetail> {
  bool _isLoading = true;
  AccountDetailData? res;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fetchAccountDetailData();
  }

  Future<void> _fetchAccountDetailData() async {
    try {
      // 비동기 작업을 시작하기 전에 로딩 상태를 true로 설정합니다.
      setState(() {
        _isLoading = true;
      });

      var resData = await getAccountDetail(widget.bankData.account_id);
      print('통신결과: $resData');
      setState(() {
        if (resData != null) {
          res = resData;
        }
      });
    } catch (error) {
      // 에러가 발생한 경우 에러 처리를 수행합니다.
      print('Error: $error');
    } finally {
      // 비동기 작업이 완료되었으므로 로딩 상태를 false로 설정합니다.
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SizedBox(
            height: 192,
            child: Center(child: CircularProgressIndicator())) // 로딩 화면을 표시합니다.
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFA0CAFD),
              title: Text(
                widget.bankData.account_name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  BankTopContainer(bankData: widget.bankData),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('생성일자 : ', style: TextStyle(fontSize: 20)),
                            Text(res?.issue_date ?? 'N/A',
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('일일 결제 한도 : ', style: TextStyle(fontSize: 20)),
                            Text(res?.day_limit_amt.toString() ?? 'N/A',
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('1회 결제 한도 : ', style: TextStyle(fontSize: 20)),
                            Text(res?.once_limit_amt.toString() ?? 'N/A',
                                style: const TextStyle(fontSize: 20))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
