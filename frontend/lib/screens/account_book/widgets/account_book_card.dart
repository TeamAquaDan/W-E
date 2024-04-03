import 'package:flutter/material.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:intl/intl.dart';

class AccountBookCard extends StatelessWidget {
  final List<dynamic> data;
  final Function setData;
  const AccountBookCard({super.key, required this.data, required this.setData});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('###,###,###,### 원');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: data.map<Widget>((x) {
          final colors = getColorByCategory(x['account_book_category']);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FormAccountBook(
                      setData: setData,
                      accountBookData: x,
                    ); // 여기에 FormAccountBook 위젯을 반환하는 코드를 작성하세요.
                  },
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: colors,
                  ),
                  Text(
                    x['account_book_dtm'].substring(5, 10),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    x['account_book_title'],
                    style: const TextStyle(
                      color: Color(0xFF0C0C0C),
                      fontSize: 16,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    x['account_book_category'] == '100'
                        ? '+ ${formatter.format((x['account_book_amt']))}'
                        : '- ${formatter.format((x['account_book_amt']))}',
                    style: TextStyle(
                      color: x['account_book_category'] == '100'
                          ? const Color(0xFF568EF8)
                          : const Color(0xFF0C0C0C),
                      fontSize: 16,
                      fontFamily: 'Aggro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color getColorByCategory(String category) {
    switch (category) {
      case '001':
        return Colors.deepOrange;
      case '002':
        return Colors.orange;
      case '003':
        return Colors.purple;
      case '004':
        return Colors.green;
      case '005':
        return Colors.red;
      case '006':
        return Colors.pink;
      case '007':
        return Colors.pinkAccent;
      case '008':
        return Colors.teal;
      case '009':
        return Colors.cyan;
      case '010':
        return Colors.deepPurple;
      case '011':
        return Colors.amber;
      case '012':
        return Colors.yellow;
      case '013':
        return Colors.lightGreen;
      case '014':
        return Colors.red;
      case '015':
        return Colors.blueGrey;
      case '000':
        return Colors.grey;
      case '100':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
