import 'package:dio/dio.dart';
import 'package:frontend/api/account_book/account_book_model.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future getAccountBook(int year, int month) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/accountbook/history?year=$year&month=$month',
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

Future getAccountBookChart(int year, int month) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/accountbook/statistics?year=$year&month=$month',
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

Future postAccountBook(AccountBook body) async {
  final DioService dioService = DioService();
  try {
    Response response =
        await dioService.dio.post('${baseURL}api/accountbook', data: body);

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

Future patchAccountBook(AccountBook body, int account_book_id) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio
        .patch('${baseURL}api/accountbook/${account_book_id}', data: body);

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

Future deleteAccountBook(AccountBook body, int account_book_id) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio
        .delete('${baseURL}api/accountbook/${account_book_id}');

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
