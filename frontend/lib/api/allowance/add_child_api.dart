import 'package:dio/dio.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future addChild({
  required int userId,
  required String groupNickname,
  required bool isMonthly,
  required int allowanceAmt,
  required int paymentDate,
  required int accountId,
  required String accountNum,
  required String accountPassword,
}) async {
  final DioService dioService = DioService();
  final Map<String, dynamic> body = {
    "user_id": userId,
    "group_nickname": groupNickname,
    "is_monthly": isMonthly,
    "allowance_amt": allowanceAmt,
    "payment_date": paymentDate,
    "account_id": accountId,
    "account_num": accountNum,
    "account_password": accountPassword
  };
  print('addChild 바디 : $body');
  try {
    Response response = await dioService.dio.post(
      '${baseURL}api/allowance/add',
      data: body,
    );

    // Handle response
    print('addChild Response status: ${response.statusCode}');
    print('addChild Response data: ${response.data}');
    // You can handle the response data here as needed
  } catch (error) {
    // Handle error
    print('addChild 에러: $error');
    // You can show an error message to the user or handle the error in another way
  }
}
// "{
//   ""user_id"": ""int, 사용자(자녀) 아이디"",
//   ""group_nickname"": ""string, 그룹 별칭""
//   ""is_monthly"": ""boolean, 용돈주기(매월)"",
//   ""allowance_amt"": ""int, 용돈 금액"",
//   ""payment_date"" : int, 용돈 지급일,
//   ""account_id"" : int, 출금 계좌 고유 번호,(18행 내 계좌 조회)
//   ""account_num"": string, 출금 계좌번호((18행 내 계좌 조회)),
//   ""account_password"" : string, 출금 계좌 비밀번호
// }

// is_monthly가 true일 경우(매월 지급)
// payment_date의 범위: 1 ~ 28일
// false일 경우(매주 지급)
// payment_date의 범위: 1(월) ~ 7(일)"

Future SearchChild({
  required String phoneNum,
  required String userName,
}) async {
  final DioService dioService = DioService();
  final Map<String, dynamic> body = {
    "phone_num": phoneNum,
    "username": userName
  };
  print('SearchChild 바디 : $body');
  try {
    Response response = await dioService.dio.post(
      '${baseURL}api/user/verify',
      data: body,
    );

    // Handle response
    // print('SearchChild Response status: ${response.statusCode}');
    print('SearchChild 결과: ${response.data}');
    // You can handle the response data here as needed
    return response.data['data']['user_id'];
  } catch (error) {
    // Handle error
    print('addChild 에러: $error');
    // You can show an error message to the user or handle the error in another way
  }
}
/*
"{
  ""phone_num"": ""string, 전화번호"", 
  ""username"": ""string, 이름""
}

전화번호 '-' 없음
"
 */