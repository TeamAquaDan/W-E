import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // 별도의 dio 인스턴스를 사용하여 인터셉터 생성
  final Dio _dio = Dio();

  AuthInterceptor() {
    // 현재 인터셉터를 _dio에 추가
    _dio.interceptors.add(this);
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
          // 리프레시 토큰을 이용해서 토큰 발급 요청
          final response = await _dio.post('https://j10e103.p.ssafy.io/api/auth/reissue', data: {'refresh_token': refreshToken});
          String newAccessToken = response.data['access_token'];

          // 새로운 액세스 토큰 저장
          await _storage.write(key: 'access_token', value: newAccessToken);

          // 기존 요청을 새로운 토큰으로 변경 후 재요청
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
