import 'package:frontend/api/save/goal_list_api.dart';
import 'package:get/get.dart';

class GoalListController extends GetxController {
  var mySavingGoals = <Map<String, dynamic>>[].obs;

  void fetchGoals() async {
    // 목표 목록을 API로부터 가져오는 로직 구현
    var fetchedGoals = await getGoalList(3); // API 호출 함수
    if (fetchedGoals != null) {
      mySavingGoals.value = fetchedGoals; // API 호출 결과가 null이 아니면 할당
    } else {
      mySavingGoals.value = []; // API 호출 결과가 null이면 빈 리스트 할당
    }
  }

  void refreshGoals() {
    fetchGoals(); // 목표 목록을 새로고침
  }
}
