import 'package:dio/dio.dart';
import 'package:frontend/models/account/transfer_data.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<String?> postTransferReceive(
    String accessToken, TransferReceivePost inputBody) async {
  final DioService dioService = DioService();
  try {
    final body = {
      'bank_code_std': inputBody.bank_code_std,
      'account_num': inputBody.account_num
    };
    Response response = await dioService.dio.post(
      '${baseURL}api/account/transfer/inquiry/receive',
      // data: requestBody,
      data: body,
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      // Check if response data contains 'data' field and if 'account_holder_name' list is not empty
      if (response.data.containsKey('data') &&
          response.data['data'].containsKey('account_holder_name') &&
          response.data['data']['account_holder_name'].isNotEmpty) {
        // Return the first item of 'account_holder_name' list
        return response.data['data']['account_holder_name'][0];
      } else {
        print('Error: No data or empty account_holder_name list in response');
        return null;
      }
    } else {
      // Handle error response
      print('Error response: ${response.data}');
      return null;
    }
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return null;
  }
}

Future<Response?> postTransfer(String accessToken, TransferPost body) async {
  final DioService dioService = DioService();
  try {
    // Dio dio = Dio();
    // dio.options.headers['Authorization'] = 'Bearer $accessToken';

    Response response = await dioService.dio.post(
      '${baseURL}api/account/transfer/withdraw',
      data: body.toMap(),
    );

    print('Response status: ${response.statusCode}');
    // print('Response status: ${response.statusMessage}');
    print('Response data: ${response.data}');
    return response;
  } catch (error) {
    print('Error sending POST request: $error');
    return null;
  }
}
