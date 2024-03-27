import 'package:flutter/material.dart';
import 'package:frontend/api/account_book/account_book_api.dart';
import 'package:frontend/api/account_book/account_book_model.dart';
import 'package:frontend/screens/account_book/form_account_book.dart';
import 'package:get/get.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Title: ${accountBookData['account_book_title']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() =>
                            FormAccountBook(accountBookData: accountBookData));
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteAccountBook(accountBookData['account_book_id']);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
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
