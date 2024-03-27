import 'package:frontend/services/dio_service.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  var accountsData = <dynamic>[].obs;
  final DioService _dioService = DioService();

  Future<void> fetchAccounts() async {
    try {
      final response = await _dioService.dio.get('YOUR_API_ENDPOINT');
      if (response.statusCode == 200) {
        var data = response.data['data'];
        if (data is List) {
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
