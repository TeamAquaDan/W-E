// import 'package:dio/dio.dart';
// import '../models/signup_request.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AuthService {
//   Dio _dio = Dio();

//   Future<bool> signup(SignupRequest request) async {
//     try {
//       final response =
//           await _dio.post('https://yourapi.com/signup', data: request.toJson());
//       if (response.statusCode == 200) {
//         // 회원가입 성공
//         return true;
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> login(String username, String password) async {
//     // 실제 API 요청 대신 항상 성공한다고 가정
//     // try {
//     //   final response = await _dio.post('https://yourapi.com/login',
//     //       data: {'username': username, 'password': password});
//     //   if (response.statusCode == 200) {
//     //     String token = response.data['token'];
//     //     await const FlutterSecureStorage().write(key: 'token', value: token);
//     //     return true;
//     //   }
//     //   return false;
//     // } catch (e) {
//     //   return false;
//     // }

//     // API가 없으므로 임시로 true 반환
//     return Future.value(true);
//   }
// }


// auth_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> signUp(String login_id, String password, String confirmpassword, String username, String birthdate, String rr_number) async {
    try {
      final response = await _dio.post(
        'https://your-server.com/signup',
        data: {
          'login_id': login_id,
          'password': password,
          'confirmpassword': confirmpassword,
          'username': username,
          'birthdate': birthdate,
          'rr_number': rr_number,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(String login_id, String password) async {
    try {
      final response = await _dio.post(
        'https://your-server.com/login',
        data: {
          'login_id': login_id,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        await _storage.write(key: 'login_id', value: login_id);
        await _storage.write(key: 'password', value: password);
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
  }

  Future<bool> tryAutoLogin() async {
    String? login_id = await _storage.read(key: 'login_id');
    String? password = await _storage.read(key: 'password');
    if (login_id != null && password != null) {
      return await login(login_id, password);
    }
    return false;
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