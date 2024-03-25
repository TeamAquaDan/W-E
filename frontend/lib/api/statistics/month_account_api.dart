import 'package:dio/dio.dart';
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/models/statistics/account_month_model.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<List<AccountBookListData>?> getMonthAccountList(
    int year, int month) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/accountbook/history?year=$year&month=$month',
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    if (response.statusCode == 200) {
      List<dynamic> jsonDataList = response.data['data'] as List<dynamic>;
      List<AccountBookListData> dataList = jsonDataList
          .map((e) => AccountBookListData.fromJson(e as Map<String, dynamic>))
          .toList();
      return dataList;
    } else {
      // Handle error
      return null;
    }
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return null;
  }
}
