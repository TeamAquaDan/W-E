import 'package:dio/dio.dart';
import 'base_url.dart';

final dio = Dio();

Future<String> requestTest() async {
  print('${baseURL}test/hello');
  Response response;

  response = await dio.get('${baseURL}fastapi/dailyword');

  print(response.data.toString());

  return response.data; // hello world
}

void request1() async {
  print('${baseURL}test/hello');
  Response response;

  response = await dio.post('${baseURL}api/insert-test');
  print(response);
  // The below request is the same as above.
  // response = await dio.get(
  //   '/test',
  //   queryParameters: {'id': 12, 'name': 'dio'},
  // );
  print(response.data.toString());
}
