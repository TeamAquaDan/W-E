import 'package:dio/dio.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<List<AccountListData>?> getAccountListData(String accessToken) async {
  final DioService _dioService = DioService();
  try {
    // Dio dio = Dio();

    // dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Make POST request
    Response response = await _dioService.dio.get(
      '${baseURL}api/account',
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response dataㄹㄹ: ${response.data}');
    List<AccountListData> accountList = (response.data['data'] as List)
        .map((item) => AccountListData.fromJson(item))
        .toList();
    return accountList;
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return null;
  }
}

Future<List<AccountHistoryData>?> getAccountHistoryData(
    String accessToken, AccountHistoryBody body) async {
  final DioService _dioService = DioService();
  // print('body status: $body');
  try {
    // Dio dio = Dio();

    // dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Make POST request
    Response response = await _dioService.dio.get(
      '${baseURL}api/account/history',
      data: body,
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response.data;
  } catch (error) {
    print('body status: $body');
    // Handle error
    print('Error sending POST request: $error');
    return null;
  }
}
