import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> signUp(String loginId, String password, String username,
      String birthdate, String personalNum) async {
    try {
      final response = await _dio.post(
        'https://j10e103.p.ssafy.io/api/auth/signup',
        data: {
          'login_id': loginId,
          'password': password,
          'username': username,
          'birthdate': birthdate,
          'personal_num': personalNum,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('에러 : $e');
      return false;
    }
  }

  Future<bool> login(String loginId, String password, String fcmToken) async {
    try {
      final response = await _dio.post(
        'https://j10e103.p.ssafy.io/api/auth/login',
        data: {
          'login_id': loginId,
          'password': password,
          'fcm_token': fcmToken
        },
      );
      if (response.statusCode == 200) {
        await _storage.write(key: 'login_id', value: loginId);
        await _storage.write(key: 'password', value: password);
        // JWT 토큰 저장
        var data = response.data['data'];
        String accessToken = data['access_token'];
        String refreshToken = data['refresh_token'];
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        String? checkAccesstoken = await _storage.read(key: 'access_token');
        String? checkRefreshtoken = await _storage.read(key: 'refresh_token');
        developer.log('access: $checkAccesstoken', name: 'check_accesstoken');
        developer.log('refresh: $checkRefreshtoken', name: 'check_refreshtoken');
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'login_id');
    await _storage.delete(key: 'password');
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<bool> tryAutoLogin() async {
    String? loginId = await _storage.read(key: 'login_id');
    String? password = await _storage.read(key: 'password');
    String? fcmToken = 'fcm_token';
    if (loginId != null && password != null) {
      developer.log('아이디: $loginId', name: 'saved_id');
      developer.log('비밀번호: $password', name: 'saved_password');
      return await login(loginId, password, fcmToken);
    }
    return false;
  }

  Future<bool> hasLoginInfo() async {
    String? loginId = await _storage.read(key: 'login_id');
    String? password = await _storage.read(key: 'password');
    return loginId != null && password != null;
  }

  // 액세스 토큰 접근용 메서드
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // 리프레시 토큰 접근용 메서드
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }
}

// PIN으로 로그인 하기
class SecurityService {
  final _storage = const FlutterSecureStorage();

  Future<void> setPin(String pin) async {
    await _storage.write(key: 'pin', value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: 'pin');
  }
}
