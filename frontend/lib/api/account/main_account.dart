import 'package:dio/dio.dart' as dio;
import 'package:frontend/models/account/account_list_data.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../base_url.dart';

Future patchMainAccount(int accountId, String accountNum) async {
  final DioService dioService = DioService();
  try {
    dio.Response response = await dioService.dio.get(
        '${baseURL}api/user/main-account',
        data: {"account_id": accountId, "account_num": accountNum});

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return true;
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return false;
  }
}
