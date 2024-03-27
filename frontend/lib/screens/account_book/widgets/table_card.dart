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
    Color cardColor = Colors.blue; // 기본 카드 색상
    if (accountBookData['account_book_category'] == '100') {
      cardColor = Colors.green;
    }
    return Card(
      color: cardColor,
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
                  '${accountBookData['account_book_title']}',
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
            Text('금액: ${accountBookData['account_book_amt']}'),
            Text('날짜: ${accountBookData['account_book_dtm']}'),
            Text(
                '카테고리: ${getCategoryName(accountBookData['account_book_category'])}'),
          ],
        ),
      ),
    );
  }

  String getCategoryName(String category) {
    switch (category) {
      case '001':
        return '식비';
      case '002':
        return '카페/간식';
      case '003':
        return '생활';
      case '004':
        return '주거/통신';
      case '005':
        return '온라인쇼핑';
      case '006':
        return '패션/쇼핑';
      case '007':
        return '뷰티/미용';
      case '008':
        return '의료/건강';
      case '009':
        return '문화/여가';
      case '010':
        return '여행/숙박';
      case '011':
        return '경조/선물';
      case '012':
        return '반려동물';
      case '013':
        return '교육/학습';
      case '014':
        return '술/유흥';
      case '015':
        return '교통';
      case '000':
        return '기타';
      case '100':
        return '수입';
      default:
        return 'Unknown';
    }
  }
}
