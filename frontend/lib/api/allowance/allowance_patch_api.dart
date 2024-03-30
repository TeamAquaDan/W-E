import 'package:dio/dio.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<Response?> patchAllowanceInfo({
  required int groupId,
  required bool isMonthly,
  required int allowanceAmt,
  required int paymentDate,
}) async {
  final DioService dioService = DioService();
  final Map<String, dynamic> body = {
    "group_id": groupId,
    "is_monthly": isMonthly,
    "allowance_amt": allowanceAmt,
    "payment_date": paymentDate,
  };
  try {
    Response response = await dioService.dio.patch(
      '${baseURL}api/allowance/info',
      data: body,
    );

    // Handle response
    print('patchAllowanceInfo Response status: ${response.statusCode}');
    print('patchAllowanceInfo Response data: ${response.data}');
    // You can handle the response data here as needed
    return response.data;
  } catch (error) {
    // Handle error
    print('patchAllowanceInfo 에러: $error');
    // You can show an error message to the user or handle the error in another way
  }
  return null;
}

Future patchAllowanceNickname({
  required int groupId,
  required String groupNickname,
}) async {
  final DioService dioService = DioService();
  final Map<String, dynamic> body = {
    "group_id": groupId,
    "group_Nickname": groupNickname,
  };
  print('그룹별칭 수정2 : $body');
  try {
    Response response = await dioService.dio.patch(
      '${baseURL}api/allowance/nickname',
      data: body,
    );

    // Handle response
    print('patchAllowanceNickname Response status: ${response.statusCode}');
    print('patchAllowanceNickname Response data: ${response.data}');
    // You can handle the response data here as needed
  } catch (error) {
    // Handle error
    print('patchAllowanceNickname 에러: $error');
    // You can show an error message to the user or handle the error in another way
  }
}
