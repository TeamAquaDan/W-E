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
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      List<dynamic> responseData = response.data['data'];
      List<Child> children =
          responseData.map((data) => Child.fromJson(data)).toList();
      return children;
    } else {
      return [
        Child(
          userId: 0,
          groupId: 0,
          profileImage: 'string profileImage',
          groupNickname: 'string groupNickname',
        )
      ];
    }
  } catch (error) {
    // Handle error
    print('Error sending POST request: $error');
    return [
      Child(
        userId: 0,
        groupId: 0,
        profileImage: 'string profileImage',
        groupNickname: 'string groupNickname',
      )
    ];
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
    print('Error sending POST request: $error');
    return ChildDetail(
        userId: 0,
        groupId: 0,
        accountNum: 'Fail:계좌번호',
        isMonthly: true,
        allowanceAmt: 33000,
        paymentDate: 15);
  }
}
