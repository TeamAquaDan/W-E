import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/screens/account_book/widgets/table_card.dart';

class AccountBookTable extends StatefulWidget {
  const AccountBookTable({super.key});

  @override
  _AccountBookTableState createState() => _AccountBookTableState();
}

class _AccountBookTableState extends State<AccountBookTable> {
  Map<String, dynamic> responseData = {};

  void fetchData() async {
    try {
      var response = await getAccountBook(2024, 3);
      setState(() {
        responseData = response;
      });
      debugPrint('데이터 통신 결과 $responseData');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: responseData.isEmpty
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("수입: ${responseData['data']['income_amt']}"),
                    Text("지출: ${responseData['data']['expense_amt']}"),
                  ],
                ),
                Column(
                  children: List.generate(
                    responseData['data']['account_book_list'].length,
                    (index) => AccountBookCard(
                      accountBookData: responseData['data']['account_book_list']
                          [index],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
