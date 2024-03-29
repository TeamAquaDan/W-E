import 'package:dio/dio.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<List<dynamic>?> getNegoList({
  required int groupId,
}) async {
  final DioService dioService = DioService();

  try {
    Response response = await dioService.dio.get('${baseURL}api/nego/$groupId');

    // Handle response
    print('patchAllowanceInfo Response status: ${response.statusCode}');
    print('patchAllowanceInfo Response data: ${response.data}');
    // You can handle the response data here as needed
    return response.data['data'];
  } catch (error) {
    // Handle error
    print('patchAllowanceInfo 에러: $error');
    // You can show an error message to the user or handle the error in another way
  }
  return null;
}
/*
"
{
  ""status"": 200, 
  ""message"": ""인상 요청 내역 조회 성공"", 
  ""data"": [
      {
            ""nego_id"": int, 인상 요청 아이디
            ""nego_amt"": int, 요청 금액
            ""create_dtm"": ""string, yyyy.mm.dd hh:mm'요청일시
            ""completed_dtm"": ""string, yyyy.mm.dd hh:mm'처리일시, 처리되지 않았을 경우 null ,
            ""status"": int, 처리 상태, 0(대기중), 1(승인), 2(거절)
            ""comment"": ""string, 승인/거절 사유"",
            ""allowance_amt"": int, 요청 당시 용돈 금액
       },
   ]
}

status=0인 인상 요청의 completed_dtm, comment은 null" 
*/

Future<List<dynamic>?> getNegoDetail({
  required int groupId,
  required int negoId,
}) async {
  final DioService dioService = DioService();

  try {
    Response response =
        await dioService.dio.get('${baseURL}api/$groupId/$negoId');

    // Handle response
    print('patchAllowanceInfo Response status: ${response.statusCode}');
    print('patchAllowanceInfo Response data: ${response.data}');
    // You can handle the response data here as needed
    return response.data['data'];
  } catch (error) {
    // Handle error
    print('patchAllowanceInfo 에러: $error');
    // You can show an error message to the user or handle the error in another way
  }
  return null;
}

Future<void> patchNego({
  required int negoId,
  required int result,
  required String comment,
}) async {
  final DioService dioService = DioService();
  Map<String, dynamic> body = {
    "nego_id": negoId,
    "result": result,
    "comment": comment,
  };
  try {
    Response response =
        await dioService.dio.patch('${baseURL}api/nego/manage', data: body);

    // Handle response
    print('patchAllowanceInfo Response status: ${response.statusCode}');
    print('patchAllowanceInfo Response data: ${response.data}');
    // You can handle the response data here as needed
    // return response.data;
  } catch (error) {
    // Handle error
    print('patchAllowanceInfo 에러: $error');
    // You can show an error message to the user or handle the error in another way
  }
  // return null;
}
