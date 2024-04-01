import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountBookCard2 extends StatelessWidget {
  final List<dynamic> data;
  const AccountBookCard2({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // print('ㅂㄴㅊㅂㄴㅊㅂㄴㅊㄴㅂ $data');
    final formatter = NumberFormat('###,###,###,### 원');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: data
            .map<Widget>(
              (x) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      x['account_book_dtm'].substring(5),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SB Aggro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      x['account_book_title'],
                      style: TextStyle(
                        color: Color(0xFF0C0C0C),
                        fontSize: 20,
                        fontFamily: 'SB Aggro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '- ${formatter.format((x['account_book_amt']))}',
                      style: TextStyle(
                        color: Color(0xFF0C0C0C),
                        fontSize: 20,
                        fontFamily: 'SB Aggro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
