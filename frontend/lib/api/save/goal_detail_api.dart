import 'package:dio/dio.dart';
import 'package:frontend/models/save/goal_add.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future getGoalDetail(int goalId) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/goal/$goalId',
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    // print('Response data data: ${response.data.data}');
    return response.data['data'];
  } catch (error) {
    print('Error sending GET request: $error');
    return null;
  }
}

class Goal {
  Goal({
    required this.goalId,
    required this.goalName,
    required this.goalAmt,
    required this.status,
    required this.startDate,
    required this.goalDate,
    required this.percentage,
    required this.savedAmt,
    required this.category,
  });

  final int goalId;
  final String goalName;
  final int goalAmt;
  final int status;
  final String startDate;
  final String goalDate;
  final double percentage;
  final int savedAmt;
  final String category;

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalId: json['goal_id'] as int,
      goalName: json['goal_name'] as String,
      goalAmt: json['goal_amt'] as int,
      status: json['status'] as int,
      startDate: json['start_date'] as String,
      goalDate: json['goal_date'] as String,
      percentage: json['percentage'] as double,
      savedAmt: json['saved_amt'] as int,
      category: json['category'] as String,
    );
  }
}
