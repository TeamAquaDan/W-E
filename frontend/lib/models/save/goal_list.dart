/*
"{
  ""status"": 200, 
  ""message"": ""목표 목록 조회 성공"", 
  ""data"": 
    [
      {
        ""goal_id"" : ""int, 목표 아이디"",
        ""goal_name"": ""string, 목표 이름"",
        ""goal_amt"" : ""int, 목표 금액"",
        ""status"" : int, 목표 상태, 0(진행중), 1(성공), 2(실패),
        ""start_date"" : ""string, yyyy.mm.dd 시작일"",
        ""withdraw_date"" : ""string, yyyy.mm.dd 출금일"",
        ""goal_date"": ""string, yyyy.mm.dd 마감일"",
        ""percentage"": int, 달성률,
        ""withdraw_amt"" : ""int, 출금한 금액"", 
        ""category"": ""String, 카테고리""
      },
    ]
}"
 */
class GetGoalListResponse {
  GetGoalListResponse({
    required this.goalId,
    required this.goalName,
    required this.goalAmt,
    required this.status,
    required this.startDate,
    required this.withdrawDate,
    required this.goalDate,
    required this.percentage,
    required this.withdrawAmt,
    required this.category,
  });

  final int goalId;
  final String goalName;
  final int goalAmt;
  final int status;
  final String startDate;
  final String withdrawDate;
  final String goalDate;
  final int percentage;
  final int withdrawAmt;
  final String category;

  factory GetGoalListResponse.fromJson(Map<String, dynamic> json) {
    return GetGoalListResponse(
      goalId: json['goal_id'] as int,
      goalName: json['goal_name'] as String,
      goalAmt: json['goal_amt'] as int,
      status: json['status'] as int,
      startDate: json['start_date'] as String,
      withdrawDate: json['withdraw_date'] as String,
      goalDate: json['goal_date'] as String,
      percentage: json['percentage'] as int,
      withdrawAmt: json['withdraw_amt'] as int,
      category: json['category'] as String,
    );
  }
}
