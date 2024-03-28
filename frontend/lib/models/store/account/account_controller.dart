import 'package:frontend/api/base_url.dart';
import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  var accountsData = <dynamic>[].obs;
  final DioService _dioService = DioService();

  Future<void> fetchAccounts() async {
    try {
      final response = await _dioService.dio.get('${baseURL}api/account');
      if (response.statusCode == 200) {
        var data = response.data['data'];
        if (data is List) {
          print('accounts 저장 성공');
          accountsData.assignAll(data.cast<dynamic>());
        }
      } else {
        print(
            'Failed to load accounts with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load accounts: $e');
    }
  }
}
