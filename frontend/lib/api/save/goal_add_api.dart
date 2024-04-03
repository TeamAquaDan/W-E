import 'package:dio/dio.dart';
import 'package:frontend/models/save/goal_add.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future postGoal(PostAddGoalBody body) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.post(
      '${baseURL}api/goal',
      data: body.toMap(),
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    return response.data;
  } catch (error) {
    print('Error sending GET request: $error');
    return null;
  }
}
