import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_service.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // 별도의 dio 인스턴스를 사용하여 인터셉터 생성
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  AuthInterceptor() {
    // 현재 인터셉터를 _dio에 추가
    _dio.interceptors.add(this);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 액세스 토큰 재발급 시도
      bool refreshed = await _authService.refreshToken();
      if (refreshed) {
        // 새로운 액세스 토큰으로 원래 요청 재시도
        final opts = err.requestOptions;
        String? newToken = await _authService.getAccessToken();
        opts.headers['Authorization'] = 'Bearer $newToken';
        try {
          // 새 토큰으로 요청 재시도
          final newResponse = await Dio().fetch(opts);
          return handler.resolve(newResponse);
        } catch (e) {
          return super.onError(err, handler);
        }
      }
    }
    return super.onError(err, handler);
  }
}
