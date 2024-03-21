import 'package:flutter/material.dart';
import 'package:frontend/api/account/account_list_api.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/models/account/dummy_data_account.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_history_card.dart';
import 'package:frontend/screens/bank_history_page/widgets/trans_type_button.dart';
import 'package:intl/intl.dart';

const List<String> trans_type_list = <String>['전체', '지출', '수입'];

class BankHistoryTable extends StatefulWidget {
  const BankHistoryTable({
    super.key,
    required this.account_id,
  });
  final int account_id;
  @override
  State<StatefulWidget> createState() {
    return _BankHistoryTable();
  }
}

class _BankHistoryTable extends State<BankHistoryTable> {
  bool _isLoading = true;
  String dropdownValue = trans_type_list.first;
  List<AccountHistoryData> filteredDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchAccountListData(); // 페이지가 렌더링되면 초기 필터링을 수행합니다.
  }

  void setDropDownValue(String value) {
    setState(() {
      dropdownValue = value;
      _fetchAccountListData();
    });
  }

  Future<void> _fetchAccountListData() async {
    try {
      // 비동기 작업을 시작하기 전에 로딩 상태를 true로 설정합니다.
      setState(() {
        _isLoading = true;
      });
      DateTime currentDate = DateTime.now();
      DateTime startDateDateTime =
          DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
      final startDate = DateFormat('yyyy-MM-dd').format(startDateDateTime);
      final endDate = DateFormat('yyyy-MM-dd').format(currentDate);
      final body = AccountHistoryBody(
          account_id: widget.account_id,
          start_date: startDate,
          end_date: endDate);
      var res = await getAccountHistoryData('accessToken', body);
      setState(() {
        if (res == null) {
          filterDataList();
        } else {
          filteredDataList = res;
        }
      });
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterDataList() {
    setState(() {
      if (dropdownValue == '전체') {
        filteredDataList = dummyDataList;
      } else if (dropdownValue == '지출') {
        filteredDataList =
            dummyDataList.where((data) => data.trans_type == 2).toList();
      } else if (dropdownValue == '수입') {
        filteredDataList =
            dummyDataList.where((data) => data.trans_type == 3).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator()) // 로딩 화면을 표시합니다.
        : Column(
            children: [
              Row(children: [
                const SizedBox(width: 20),
                DropdownButtonHistory(
                  trans_type_list: trans_type_list,
                  dropdownValue: dropdownValue,
                  setDropDownValue: setDropDownValue,
                ),
                const Spacer(),
                Text(dropdownValue)
              ]),
              for (int i = 0; i < filteredDataList.length; i++)
                BankHistoryCard(data: filteredDataList[i])
            ],
          );
  }
}
