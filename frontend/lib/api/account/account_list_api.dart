import 'package:dio/dio.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<List<AccountListData>?> getAccountListData(String accessToken) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/account',
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
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

Future<AccountDetailData?> getAccountDetail(int account_id) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/account/detail',
      data: account_id,
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    // Check if response data contains 'data' field and if it's not null
    if (response.data.containsKey('data') && response.data['data'] != null) {
      AccountDetailData accountDetail =
          AccountDetailData.fromJson(response.data);

      return accountDetail;
    } else {
      print('Error: No data field or null data in response');
      return null;
    }
  } catch (error) {
    print('account_id status: $account_id');
    print('Error sending POST request: $error');
    return null;
  }
}

Future<List<AccountHistoryData>?> getAccountHistoryData(
    String accessToken, AccountHistoryBody body) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/account/history',
      data: body.toMap(),
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    // Check if response data contains 'data' field and if it's not null
    if (response.data.containsKey('data') && response.data['data'] != null) {
      List<AccountHistoryData> accountList = (response.data['data'] as List)
          .map((item) => AccountHistoryData.fromJson(item))
          .toList();
      return accountList;
    } else {
      print('Error: No data field or null data in response');
      return null;
    }
  } catch (error) {
    print('body status: $body');
    print('Error sending POST request: $error');
    return null;
  }
}
