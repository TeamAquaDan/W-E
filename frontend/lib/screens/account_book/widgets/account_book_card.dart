import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountBookCard extends StatelessWidget {
  final List<dynamic> data;
  const AccountBookCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'SB Aggro',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      x['account_book_title'],
                      style: const TextStyle(
                        color: Color(0xFF0C0C0C),
                        fontSize: 20,
                        fontFamily: 'SB Aggro',
                        fontWeight: FontWeight.w400,
                        height: 0,
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
