import 'package:frontend/models/user/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var user = User(userId: 0).obs; // 초깃값을 int로 설정

  void setUserId(int userId) {
    user.update((val) {
      val?.userId = userId; // userId를 업데이트
    });
  }

  int getUserId() {
    return user.value.userId; // 현재 userId를 반환
  }
}
