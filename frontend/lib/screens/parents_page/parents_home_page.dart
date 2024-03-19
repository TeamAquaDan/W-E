import 'package:flutter/material.dart';
import 'package:frontend/models/account_list_data.dart';
import 'package:frontend/screens/parents_page/children_page/parents_children_page.dart';
import 'package:frontend/widgets/bank_book.dart';
import 'package:frontend/widgets/carousel_with_indicator.dart';
import 'package:frontend/widgets/mission_none.dart';
import 'package:frontend/widgets/pin_money.dart';

class ParentsHomePage extends StatelessWidget {
  ParentsHomePage({super.key});
  final List<AccountListData> _accountListData = [
    AccountListData(
      account_id: 1,
      account_name: 'bank Book 1',
      account_num: '111-1234-12345',
      balance_amt: 3630000,
      account_type: 0,
    ),
    AccountListData(
      account_id: 2,
      account_name: '계좌명 2',
      account_num: '222-1234-12345',
      balance_amt: 222000,
      account_type: 0,
    ),
    AccountListData(
      account_id: 3,
      account_name: '은행 통장 3',
      account_num: '333-1234-12345',
      balance_amt: 3333000,
      account_type: 0,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/whale.png',
              height: 32,
            ),
            const Text('Whale 부모 페이지'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselWithIndicator(
                height: 176,
                itemList: [
                  //계좌 목록 조회 17
                  for (int i = 0; i < _accountListData.length; i++)
                    BankBook(
                      bankData: _accountListData[i],
                    ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '자녀 용돈 목록',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        toParentsChildren(context);
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        '+ 더보기',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                children: [
                  PinMoney(
                    PinMoneyDay: 16,
                    PinMoneyMoney: 100000,
                    childName: '김자녀',
                  ),
                  PinMoney(
                    PinMoneyDay: 16,
                    PinMoneyMoney: 50000,
                    childName: '김막내',
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '진행 중인 미션',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        toParentsChildren(context);
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        '+ 더보기',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const MissionNone(),
            ],
          ),
        ),
      ),
    );
  }

  void toParentsChildren(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParentsChildrenPage()),
    );
  }
}

/*자녀 목록 조회 
"{
  ""status"": 200,
  ""message"": ""자녀 목록 조회 성공"", 
  ""data"": [
     {
         ""user_id"" ; int, 자녀 아이디,
         ""group_id"" : int, 그룹 아이디
         ""profile_image"": ""string, 자녀 프로필이미지"", 
         ""group_nickname"": ""string, 그룹 별칭""
     },
  ]
}"

*/