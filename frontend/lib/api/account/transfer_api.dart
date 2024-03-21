import 'package:dio/dio.dart';
import 'package:frontend/models/account/transfer_data.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<TransferReceiveResponse?> postTransferReceive(
    String accessToken, TransferReceivePost body) async {
  final DioService _dioService = DioService();
  try {
    Response response = await _dioService.dio.post(
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
  final DioService _dioService = DioService();
  try {
    // Dio dio = Dio();
    // dio.options.headers['Authorization'] = 'Bearer $accessToken';

    Response response = await _dioService.dio.post(
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
