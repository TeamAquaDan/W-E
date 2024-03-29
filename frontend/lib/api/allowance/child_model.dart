class Child {
  final int userId;
  final int groupId;
  final String? profileImage;
  final String groupNickname;

  Child({
    required this.userId,
    required this.groupId,
    required this.profileImage,
    required this.groupNickname,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      userId: json['user_id'] as int,
      groupId: json['group_id'] as int,
      profileImage: json['profile_image'] as String? ?? '',
      groupNickname: json['group_nickname'] != null
          ? json['group_nickname'] as String
          : '기본 닉네임',
    );
  }
}

class ChildDetail {
  final int userId;
  final int groupId;
  final String accountNum;
  final bool isMonthly;
  final int allowanceAmt;
  final int paymentDate;

  ChildDetail({
    required this.userId,
    required this.groupId,
    required this.accountNum,
    required this.isMonthly,
    required this.allowanceAmt,
    required this.paymentDate,
  });

  factory ChildDetail.fromJson(Map<String, dynamic> json) {
    return ChildDetail(
      userId: json['user_id'] as int,
      groupId: json['group_id'] as int,
      accountNum: json['account_num'] != null
          ? json['account_num'] as String
          : '자녀가 아직 계좌를 등록 안 했습니다',
      isMonthly: json['is_monthly'] as bool,
      allowanceAmt: json['allowance_amt'] as int,
      paymentDate: json['payment_date'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'group_id': groupId,
      'account_num': accountNum ?? '자녀가 아직 계좌를 등록 안 했습니다',
      'is_monthly': isMonthly,
      'allowance_amt': allowanceAmt,
      'payment_date': paymentDate,
    };
  }
}
