import 'package:dio/dio.dart' as dio;
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future patchMainAccount(int accountId, String accountNum) async {
  print('인풋ㄱ밧 $accountId $accountNum');
  final DioService dioService = DioService();
  try {
    dio.Response response = await dioService.dio.patch(
        '${baseURL}api/user/main-account',
        data: {"account_id": accountId, "account_num": accountNum});

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    if (response.statusCode == 200) {
      return true;
    }
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return false;
  }
}
