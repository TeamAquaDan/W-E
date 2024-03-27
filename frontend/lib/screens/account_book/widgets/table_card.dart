import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_model.dart';

class AccountBookCard extends StatelessWidget {
  final Map<String, dynamic> accountBookData;

  const AccountBookCard({Key? key, required this.accountBookData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${accountBookData['account_book_title']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Amount: ${accountBookData['account_book_amt']}'),
            Text('Date: ${accountBookData['account_book_dtm']}'),
            Text('Category: ${accountBookData['account_book_category']}'),
          ],
        ),
      ),
    );
  }
}
