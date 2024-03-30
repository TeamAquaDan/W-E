import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/widgets/table_card.dart';

class AccountBookTable extends StatefulWidget {
  const AccountBookTable(
      {super.key, required this.data, required this.setData});
  final Map<String, dynamic> data;
  final Function setData;
  @override
  _AccountBookTableState createState() => _AccountBookTableState();
}

class _AccountBookTableState extends State<AccountBookTable> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.data.isEmpty
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("수입: ${widget.data['data']['income_amt']}"),
                    Text("지출: ${widget.data['data']['expense_amt']}"),
                  ],
                ),
                Column(
                  children: List.generate(
                    widget.data['data']['account_book_list'] != null
                        ? widget.data['data']['account_book_list'].length
                        : 0,
                    (index) => AccountBookCard(
                      accountBookData: widget.data['data']['account_book_list']
                          [index],
                      setData: widget.setData,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
