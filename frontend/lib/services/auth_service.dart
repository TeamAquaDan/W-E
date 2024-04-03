import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'dart:developer' as developer;
import 'package:frontend/main.dart';
import 'package:frontend/models/store/userRole/user_role.dart';
import 'package:get/get.dart';
import 'dio_service.dart';

// 로그인 결과 처리
class LoginResult {
  final bool isSuccess;
  final String? role;

  LoginResult({required this.isSuccess, this.role});
}

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final SecurityService _securityService = SecurityService();
  final DioService _dioService = DioService();

  Future<bool> hasPin() async {
    String? pin = await _securityService.getPin();
    return pin != null;
  }

  Future<bool> refreshToken() async {
    print('토큰 재발급');
    try {
      String? refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final response = await _dioService.dio.post(
        '${baseURL}api/auth/reissue',
        data: {'refresh_token': refreshToken},
      );
      if (response.statusCode == 200) {
        String newAccessToken = response.data['access_token'];
        await _storage.write(key: 'access_token', value: newAccessToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp(String loginId, String password, String username,
      String birthdate, String personalNum) async {
    try {
      final response = await _dio.post(
        '${baseURL}api/auth/signup',
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

  // Future<bool> login(String loginId, String password, String fcmToken) async {
  //   try {
  //     final response = await _dio.post(
  //       '${baseURL}api/auth/login',
  //       data: {
  //         'login_id': loginId,
  //         'password': password,
  //         'fcm_token': fcmToken
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       await _storage.write(key: 'login_id', value: loginId);
  //       await _storage.write(key: 'password', value: password);
  //       // JWT 토큰 저장
  //       var data = response.data['data'];
  //       String accessToken = data['access_token'];
  //       String refreshToken = data['refresh_token'];
  //       await _storage.write(key: 'access_token', value: accessToken);
  //       await _storage.write(key: 'refresh_token', value: refreshToken);
  //       String? checkAccesstoken = await _storage.read(key: 'access_token');
  //       String? checkRefreshtoken = await _storage.read(key: 'refresh_token');
  //       developer.log('access: $checkAccesstoken', name: 'check_accesstoken');
  //       developer.log('refresh: $checkRefreshtoken', name: 'check_refreshtoken');
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  Future<LoginResult> login(
      String loginId, String password, String fcmToken) async {
    try {
      final response = await _dio.post(
        '${baseURL}api/auth/login',
        data: {
          'login_id': loginId,
          'password': password,
          'fcm_token': fcmToken,
        },
      );
      if (response.statusCode == 200) {
        await _storage.write(key: 'login_id', value: loginId);
        await _storage.write(key: 'password', value: password);
        // JWT 토큰 저장
        var data = response.data['data'];
        String accessToken = data['access_token'];
        String refreshToken = data['refresh_token'];
        String role = response.data['data']['role'];
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        await _storage.write(key: 'user_role', value: role); // 사용자 역할 저장
        String? checkAccesstoken = await _storage.read(key: 'access_token');
        String? checkRefreshtoken = await _storage.read(key: 'refresh_token');
        developer.log('access: $checkAccesstoken', name: 'check_accesstoken');
        developer.log('refresh: $checkRefreshtoken',
            name: 'check_refreshtoken');

        Get.find<UserController>().setUserId(data['user_id']);
        Get.find<UserController>().setUserName(data['username']);
        Get.find<UserRoleController>().setUserRole(role);
        return LoginResult(isSuccess: true, role: role);
      }
      // 실패 시 역할 정보 없이 반환
      return LoginResult(isSuccess: false, role: null);
    } catch (e) {
      print(e);
      return LoginResult(isSuccess: false, role: null);
    }
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: 'user_role');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'login_id');
    await _storage.delete(key: 'password');
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'pin');
  }

  Future<LoginResult> tryAutoLogin() async {
    String? loginId = await _storage.read(key: 'login_id');
    String? password = await _storage.read(key: 'password');
    String? fcmToken = globalFCMToken;
    if (loginId != null && password != null && fcmToken != null) {
      developer.log('아이디: $loginId', name: 'saved_id');
      developer.log('비밀번호: $password', name: 'saved_password');
      developer.log('fcm_token: $fcmToken', name: 'fcm_token');
      return await login(loginId, password, fcmToken);
    }
    // 저장된 로그인 정보가 없거나 로그인 실패 시 기본 LoginResult 반환
    return LoginResult(isSuccess: false, role: null);
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