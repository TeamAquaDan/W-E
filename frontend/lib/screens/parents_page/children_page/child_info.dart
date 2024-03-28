import 'package:flutter/material.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/screens/parents_page/widgets/child_card.dart';
import 'package:frontend/widgets/pin_money.dart';

class ChildInfo extends StatelessWidget {
  const ChildInfo({super.key, required this.data});
  final Child data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ChildCard(
              groupId: data.groupId,
              userId: data.userId,
              groupNickname: data.groupNickname),
          //미션 추가
        ],
      ),
    );
  }
}

/*자녀 상세 조회
"{
  ""user_id"" : int, 자녀 아이디
}"
"{
  ""status"": 200,
  ""message"": ""자녀 상세 조회 성공"", 
  ""data"": {
     ""user_id"" : int, 자녀 아이디,
     ""group_id"": int, 그룹 아이디
     ""account_num"": ""string, 자녀 계좌번호"",
     ""is_monthly"": ""boolean, 용돈주기(매월)"", 
     ""allowance_amt"": ""int, 용돈 금액"", 
     ""payment_date"": ""int, 용돈 지급일"", 
     ""group_id"": ""int, 그룹아이디""
  }
}"
 */