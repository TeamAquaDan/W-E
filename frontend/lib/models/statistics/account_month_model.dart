/**
"{
  ""status"": 200,
  ""message"": ""수입/지출 내역 조회 성공"", 
  ""data"": {
       ""income_amt"": int, 한 달 수입액,
       ""expense_amt"": int, 한 달 지출액,
       ""account_book_list"": [
         {
            ""account_book_id"" : ""int, 가계부 내역 아이디"",
            ""trans_id"" : ""int, 거래 고유 번호, 수입일 경우 0
            ""account_book_title"" : ""string, 거래 제목"",
            ""account_book_amt"" : ""int, 거래 금액"",
            ""account_book_dtm"" : 'string, 거래 일시 yyyy-MM-dd hh:mm"",
            ""account_book_category"" : ""string, 카테고리"" (코드 페이지 참고)
         },
       ]
  } 
}"
 */
class AccountBookListData {
  final int incomeAmt;
  final int expenseAmt;
  final List<AccountBookItem> accountBookList;

  AccountBookListData({
    required this.incomeAmt,
    required this.expenseAmt,
    required this.accountBookList,
  });

  factory AccountBookListData.fromJson(Map<String, dynamic> json) {
    var accountBookList = json['account_book_list'] as List<dynamic>;
    List<AccountBookItem> accountBookItems = accountBookList
        .map((e) => AccountBookItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return AccountBookListData(
      incomeAmt: json['income_amt'] as int,
      expenseAmt: json['expense_amt'] as int,
      accountBookList: accountBookItems,
    );
  }
}

class AccountBookItem {
  final int accountBookId;
  final int transId;
  final String accountBookTitle;
  final int accountBookAmt;
  final String accountBookDtm;
  final String accountBookCategory;

  AccountBookItem({
    required this.accountBookId,
    required this.transId,
    required this.accountBookTitle,
    required this.accountBookAmt,
    required this.accountBookDtm,
    required this.accountBookCategory,
  });

  factory AccountBookItem.fromJson(Map<String, dynamic> json) {
    return AccountBookItem(
      accountBookId: json['account_book_id'] as int,
      transId: json['trans_id'] as int,
      accountBookTitle: json['account_book_title'] as String,
      accountBookAmt: json['account_book_amt'] as int,
      accountBookDtm: json['account_book_dtm'] as String,
      accountBookCategory: json['account_book_category'] as String,
    );
  }
}
