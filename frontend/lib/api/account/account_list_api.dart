import 'package:dio/dio.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/models/account/transfer_data.dart';
import '../base_url.dart';

Future<List<AccountListData>?> getAccountListData(String accessToken) async {
  try {
    Dio dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Make POST request
    Response response = await dio.get(
      '${baseURL}api/account',
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response.data;
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return null;
  }
}

Future<AccountHistoryData?> getAccountHistoryData(
    String accessToken, AccountHistoryBody body) async {
  try {
    Dio dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Make POST request
    Response response = await dio.get(
      '${baseURL}api/account/history',
      data: body,
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response.data;
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return null;
  }
}
