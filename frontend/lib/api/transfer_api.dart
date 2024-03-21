import 'package:dio/dio.dart';
import 'package:frontend/models/transfer_data.dart';
import 'base_url.dart';

Future<TransferReceiveResponse?> postTransferReceive(
    String accessToken, TransferReceivePost body) async {
  try {
    // Replace 'YOUR_ACCESS_TOKEN' with your actual access token
    // String accessToken = accessToken;

    // Define the request body
    // Map<String, dynamic> requestBody = {
    //   'bank_code_std': body.bank_code_std,
    //   'account_num': body.account_num,
    // };

    // Create Dio instance
    Dio dio = Dio();

    // Add authorization header
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Make POST request
    Response response = await dio.post(
      '${baseURL}api/account/transfer/inquiry/receive',
      // data: requestBody,
      data: body,
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response.data;
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return null;
  }
}

Future<Response?> postTransfer(String accessToken, TransferPost body) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    Response response = await dio.post(
      '${baseURL}api/account/transfer/inquiry/receive',
      data: body,
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
