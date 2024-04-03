class AccountBook {
  String accountBookTitle;
  int? accountAmount;
  String accountBookDate;
  String accountBookCategory;

  AccountBook({
    required this.accountBookTitle,
    required this.accountAmount,
    required this.accountBookDate,
    required this.accountBookCategory,
  });

  // AccountBook 객체를 Map으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'account_book_title': accountBookTitle,
      'account_amt': accountAmount ?? 0,
      'account_book_date': accountBookDate,
      'account_book_category': accountBookCategory,
    };
  }

  factory AccountBook.fromJson(Map<String, dynamic> json) {
    return AccountBook(
      accountBookTitle: json['account_book_title'],
      accountAmount: json['account_amt'] ?? 0,
      accountBookDate: json['account_book_date'],
      accountBookCategory: json['account_book_category'],
    );
  }
}
