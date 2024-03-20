import 'package:flutter/material.dart';
import 'package:frontend/models/dummy_data_account.dart';
import 'package:frontend/screens/bank_history_page/widgets/bank_history_card.dart';
import 'package:frontend/screens/bank_history_page/widgets/trans_type_button.dart';

const List<String> trans_type_list = <String>['전체', '지출', '수입'];

class BankHistoryTable extends StatefulWidget {
  const BankHistoryTable({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BankHistoryTable();
  }
}

class _BankHistoryTable extends State<BankHistoryTable> {
  String dropdownValue = trans_type_list.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          SizedBox(width: 20),
          DropdownButtonHistory(
            trans_type_list: trans_type_list,
            dropdownValue: dropdownValue,
          ),
          Spacer(),
          Text(dropdownValue)
        ]),
        for (int i = 0; i < dummyDataList.length; i++)
          BankHistoryCard(data: dummyDataList[i])
      ],
    );
  }
}
