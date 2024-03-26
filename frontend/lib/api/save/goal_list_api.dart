import 'package:dio/dio.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<List<Map<String, dynamic>>?> getGoalList(int status) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/goal/search?status=$status',
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      // Check if response data contains 'data' field and if it's not null
      if (response.data.containsKey('data') && response.data['data'] != null) {
        dynamic responseData = response.data['data'];
        // Check if 'goal_list' field exists and is a list
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('goal_list') &&
            responseData['goal_list'] is List) {
          List<dynamic> goalListData = responseData['goal_list'];
          List<Map<String, dynamic>> goalList = goalListData
              .map<Map<String, dynamic>>((item) {
                if (item is Map<String, dynamic>) {
                  return {
                    'goal_id': item['goal_id'],
                    'goal_name': item['goal_name'],
                    'goal_amt': item['goal_amt'],
                    'status': item['status'],
                    'start_date': item['start_date'],
                    'withdraw_date': item['withdraw_date'] ?? '',
                    'end_date':
                        item['goal_date'], // Renaming 'goal_date' to 'end_date'
                    'percentage': item['percentage'],
                    'saved_amt': item[
                        'withdraw_amt'], // Renaming 'withdraw_amt' to 'saved_amt'
                  };
                } else {
                  print('Error: Item is not a Map<String, dynamic>');
                  return {};
                }
              })
              .where((item) => item != null)
              .toList();
          return goalList;
        } else {
          print('Error: No or invalid goal_list field in response data');
          return null;
        }
      } else {
        print('Error: No data field or null data in response');
        return null;
      }
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error sending GET request: $error');
    return null;
  }
}
