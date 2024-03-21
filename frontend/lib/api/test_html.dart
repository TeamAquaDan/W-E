import 'package:dio/dio.dart';
import 'base_url.dart';

final dio = Dio();

void request() async {
  print('${baseURL}test/hello');
  Response response;
  // response = await dio.get('http://j10e103.p.ssafy.io:56143/test/hello');
  response = await dio.get('${baseURL}test/hello');
  print(response.data.toString());
  // The below request is the same as above.
  // response = await dio.get(
  //   '/test',
  //   queryParameters: {'id': 12, 'name': 'dio'},
  // );
  print(response.data.toString());
}
