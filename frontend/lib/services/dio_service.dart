import 'package:dio/dio.dart';
import 'auth_service.dart';

class DioService {
  Dio dio = Dio();

  DioService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        AuthService authService = AuthService();
        String? accessToken = await authService.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
          // print(options.headers['Authorization']);
        }
        return handler.next(options); // 요청을 계속 진행
      },
    ));
  }
}
