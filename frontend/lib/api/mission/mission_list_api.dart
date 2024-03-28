import 'package:dio/dio.dart' as dio;
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';
import 'package:frontend/models/mission/mission_model.dart';

Future<List<MissionModel>> getMissionList(int groupId) async {
  final DioService dioService = DioService();
  try {
    dio.Response response = await dioService.dio.get(
      '${baseURL}api/mission/$groupId',
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      List<dynamic> responseData = response.data['data'];
      List<MissionModel> missionList =
          responseData.map((data) => MissionModel.fromJson(data)).toList();
      return missionList;
    } else {
      // Handle other status codes if needed
      return [
        MissionModel(
            missionId: -1,
            missionName: '없어요',
            missionReward: 123000,
            deadlineDate: '2000-04-04',
            status: 0,
            userName: '없어요')
      ];
    }
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return [
      MissionModel(
          missionId: -1,
          missionName: '없어요',
          missionReward: 123000,
          deadlineDate: '2000-04-04',
          status: 0,
          userName: '없어요')
    ];
  }
}
