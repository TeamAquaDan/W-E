import 'package:dio/dio.dart';
import 'package:frontend/api/allowance/child_model.dart';
import 'package:frontend/services/dio_service.dart';
import '../base_url.dart';

Future<List<Child>> getChildren() async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/allowance/children',
    );

    // Handle response
    print('getChildren 결과 Response status: ${response.statusCode}');
    print('getChildren 결과 Response data: ${response.data}');

    if (response.statusCode == 200) {
      List<dynamic> responseData = response.data['data'];
      List<Child> children =
          responseData.map((data) => Child.fromJson(data)).toList();
      if (children.isEmpty) {
        return [];
      }
      return children;
    } else {
      return [];
    }
  } catch (error) {
    // Handle error
    print('getChildren get 에러: $error');
    return [];
  }
}

Future<ChildDetail> getChildDetail(int groupId, int userId) async {
  final DioService dioService = DioService();
  try {
    Response response = await dioService.dio.get(
      '${baseURL}api/allowance/children/$groupId/$userId',
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.data['data'];
      ChildDetail child = ChildDetail.fromJson(responseData);
      return child;
    } else {
      return ChildDetail(
          userId: 0,
          groupId: 0,
          accountNum: 'Fail:계좌번호',
          isMonthly: true,
          allowanceAmt: 33000,
          paymentDate: 15);
    }
  } catch (error) {
    // Handle error
    print('getChildDetail get 에러: $error');
    return ChildDetail(
        userId: 0,
        groupId: 0,
        accountNum: 'Fail:계좌번호',
        isMonthly: true,
        allowanceAmt: 33000,
        paymentDate: 15);
  }
}
