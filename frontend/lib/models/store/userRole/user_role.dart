import 'package:get/get.dart';

class UserRoleController extends GetxController {
  String userRole = 'user';

  String getUserRole() {
    return userRole;
  }

  void setUserRole(String role) {
    userRole = role;
    update();
  }
}

// class UserRole {
//   String userRole;
//   UserRole({required this.userRole});
// }
