import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;
import 'package:frontend/main.dart';

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> signUp(String login_id, String password, String username,
      String birthdate, String personal_num) async {
    try {
      final response = await _dio.post(
        'https://j10e103.p.ssafy.io/api/auth/signup',
        data: {
          'login_id': login_id,
          'password': password,
          'username': username,
          'birthdate': birthdate,
          'personal_num': personal_num,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('에러 : ${e}');
      return false;
    }
  }

  Future<bool> login(String login_id, String password, String fcm_token) async {
    try {
      final response = await _dio.post(
        'https://j10e103.p.ssafy.io/api/auth/login',
        data: {
          'login_id': login_id,
          'password': password,
          'fcm_token': fcm_token
        },
      );
      if (response.statusCode == 200) {
        await _storage.write(key: 'login_id', value: login_id);
        await _storage.write(key: 'password', value: password);
        // JWT 토큰 저장
        var data = response.data['data'];
        String accessToken = data['access_token'];
        String refreshToken = data['refresh_token'];
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        String? check_accesstoken = await _storage.read(key: 'access_token');
        String? check_refreshtoken = await _storage.read(key: 'refresh_token');
        developer.log('access: ${check_accesstoken}', name: 'check_accesstoken');
        developer.log('refresh: ${check_refreshtoken}', name: 'check_refreshtoken');
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
    String? login_id = await _storage.read(key: 'login_id');
    String? password = await _storage.read(key: 'password');
    String? fcm_token = globalFCMToken;
    if (login_id != null && password != null) {
      developer.log('아이디: ${login_id}', name: 'saved_id');
      developer.log('비밀번호: ${password}', name: 'saved_password');
      developer.log('fcm_token: ${fcm_token}', name: 'fcm_token');
      return await login(login_id, password, fcm_token!);
    }
    return false;
  }

  Future<bool> hasLoginInfo() async {
    String? login_id = await _storage.read(key: 'login_id');
    String? password = await _storage.read(key: 'password');
    return login_id != null && password != null;
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
  final _storage = FlutterSecureStorage();

  Future<void> setPin(String pin) async {
    await _storage.write(key: 'pin', value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: 'pin');
  }
}
