import 'package:flutter/material.dart';
import 'package:frontend/screens/parents_page/children_page/widgets/parents_mission_list.dart';
import 'package:frontend/widgets/pin_money.dart';

class ChildInfo extends StatelessWidget {
  const ChildInfo({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PinMoney(
            PinMoneyDay: 16,
            PinMoneyMoney: 100000,
            childName: name,
          ),
          const ParentsMissionList(),
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