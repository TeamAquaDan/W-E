class AccountBook {
  String accountBookTitle;
  int accountAmount;
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
      'account_amt': accountAmount,
      'account_book_date': accountBookDate,
      'account_book_category': accountBookCategory,
    };
  }
}
