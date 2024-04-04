// "{
//   ""goal_name"": ""string, 목표 이름"",
//   ""goal_amt"": ""int, 목표 금액"",
//   ""goal_date"": ""String, 목표 날짜"",
//   ""category"": ""string, 카테고리"",
//   ""account_id"" : ""int, 저축할 통장 아이디""
// }"
class PostAddGoalBody {
  PostAddGoalBody({
    required this.goal_name,
    required this.goal_amt,
    required this.goal_date,
    required this.category,
    required this.account_id,
  });

  final String goal_name;
  final int goal_amt;
  final String goal_date;
  final String category;
  final int account_id;

  Map<String, dynamic> toMap() {
    return {
      'goal_name': goal_name,
      'goal_amt': goal_amt,
      'goal_date': goal_date,
      'category': category,
      'account_id': account_id
    };
  }
}

/*
"{
  ""status"": 200, 
  ""message"": ""목표 등록 성공"", 
  ""data"": {
    ""goal_id"" : ""int, 목표 아이디"",
    ""goal_name"": ""string, 목표 이름"",
    ""goal_amt"" : ""int, 목표 금액"",
    ""status"" : int, 목표 상태, 0(진행중), 1(성공), 2(실패),
    ""start_date"" : ""string, yyyy.mm.dd 시작일"",
    ""withdraw_date"" : ""string, yyyy.mm.dd 출금일"",
    ""goal_date"": ""string, yyyy.mm.dd 마감일"",
    ""percentage"": int, 달성률,
    ""saved_amt"" ; int, 파킹통장 현재 잔액
  }
}"
 */
class PostAddGoalResponse {
  PostAddGoalResponse({
    required this.goalId,
    required this.goalName,
    required this.goalAmt,
    required this.status,
    required this.startDate,
    required this.goalDate,
    required this.percentage,
    required this.savedAmt,
  });

  final int goalId;
  final String goalName;
  final int goalAmt;
  final int status;
  final String startDate;
  final String goalDate;
  final int percentage;
  final int savedAmt;

  factory PostAddGoalResponse.fromJson(Map<String, dynamic> json) {
    return PostAddGoalResponse(
      goalId: json['goal_id'] as int,
      goalName: json['goal_name'] as String,
      goalAmt: json['goal_amt'] as int,
      status: json['status'] as int,
      startDate: json['start_date'] as String,
      goalDate: json['goal_date'] as String,
      percentage: json['percentage'] as int,
      savedAmt: json['saved_amt'] as int,
    );
  }
}
