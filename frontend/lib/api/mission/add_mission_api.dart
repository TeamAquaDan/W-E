import 'package:dio/dio.dart' as dio;
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future addMission({
  required int groupId,
  required String missionName,
  required int missionReward,
  required String deadlineDate,
}) async {
  final DioService dioService = DioService();
  try {
    Map<String, dynamic> body = {
      "group_id": groupId,
      "mission_name": missionName,
      "mission_reward": missionReward,
      "deadline_date": deadlineDate,
    };
    print('미션추가 바디 :  $body');
    dio.Response response =
        await dioService.dio.post('${baseURL}api/mission', data: body);

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response.data;
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    rethrow;
  }
}

Future<Map<String, dynamic>> patchMission({
  required int groupId,
  required int missionId,
  required int status,
}) async {
  final DioService dioService = DioService();
  try {
    Map<String, dynamic> body = {
      "group_id": groupId,
      "mission_id": missionId,
      "status": status, //1성공 2실패
    };
    dio.Response response =
        await dioService.dio.patch('${baseURL}api/mission', data: body);

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response.data;
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    rethrow;
  }
}
