// // lib/services/auth_interceptor.dart
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AuthInterceptor extends Interceptor {
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     String? token = await _storage.read(key: 'access_token');
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//     super.onRequest(options, handler);
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio(); // 별도의 Dio 인스턴스를 사용하여 리프레시 토큰 요청을 처리합니다.

  AuthInterceptor() {
    _dio.interceptors.add(this); // 현재 인터셉터를 _dio 인스턴스에 추가합니다.
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      RequestOptions options = err.requestOptions;

      String? refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        try {
          // 리프레시 토큰을 사용하여 새 액세스 토큰을 요청합니다. 이 URL은 예시로, 실제 애플리케이션에 맞는 URL을 사용하세요.
          final response = await _dio.post('https://j10e103.p.ssafy.io/api/auth/reissue', data: {'refresh_token': refreshToken});
          String newAccessToken = response.data['access_token'];

          // 새 액세스 토큰을 저장합니다.
          await _storage.write(key: 'access_token', value: newAccessToken);

          // 원래의 요청을 새 액세스 토큰으로 수정하고 재시도합니다.
          options.headers['Authorization'] = 'Bearer $newAccessToken';
          final newResponse = await _dio.fetch(options);

          return handler.resolve(newResponse);
        } catch (e) {
          return super.onError(err, handler);
        }
      }
    }
    return super.onError(err, handler);
  }
}
