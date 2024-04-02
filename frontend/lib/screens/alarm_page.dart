import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/store/user/user_controller.dart';
import '../services/dio_service.dart';
import '../api/base_url.dart';
import 'dutchpay_page/dutchpay_page.dart';
import 'friends_page/my_friends_page.dart';
import 'mission_page/my_mission_page.dart';
import 'parents_page/parent_page.dart';
import 'profile_page/my_profile_page.dart';
import 'salary_page/salary_list_page.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late Future<List<Notification>> notifications;
  final DioService _dioService = DioService();

  @override
  void initState() {
    super.initState();
    notifications = fetchNotifications();
  }

  void navigateBasedOnCategory(String category) {
    print(category);
    switch (category) {
      case '100':
        Get.to(() => const MyFriendsPage());
        break;
      case '101':
        Get.to(() => const MyFriendsPage());
        break;
      case '300':
        Get.to(() => const MyMissionPage());
        break;
      case '301':
        Get.to(() => const MyMissionPage());
        break;
      case '400':
        Get.to(() => const ParentPage());
        break;
      case '401':
        Get.to(() => const SalaryListPage());
        break;
      case '500':
        Get.to(() => const DutchPayPage());
        break;
      case '501':
        Get.to(() => const DutchPayPage());
        break;
      case '502':
        Get.to(() => const DutchPayPage());
        break;
      case '600':
        var userId = Get.find<UserController>().getUserId();
        Get.to(() => MyProfilePage(userId: userId));
        break;
      case '700':
        Get.to(() => const SalaryListPage());
        break;
      default:
        Get.to(() => const AlarmPage());
        break;
    }
  }

  Future<List<Notification>> fetchNotifications() async {
    try {
      var response = await _dioService.dio.get('${baseURL}api/noti');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => Notification.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 페이지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () async {
              await _dioService.dio.patch('${baseURL}api/noti/read-all');
              // 상태 업데이트를 위한 페이지 새로고침
              setState(() {
                notifications = fetchNotifications();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Notification>>(
        future: notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Notification notification = snapshot.data![index];
                return ListTile(
                  title: Text(notification.name),
                  subtitle: Text(notification.content),
                  trailing:
                      notification.isRead ? null : const Icon(Icons.fiber_new),
                  tileColor:
                      notification.isRead ? Colors.white : Colors.grey[300],
                  onTap: () async {
                    // 알림 클릭 시
                    if (!notification.isRead) {
                      // 알림 클릭 시 로직 구현
                      await _dioService.dio
                          .patch('${baseURL}api/noti/${notification.notiId}');
                      // 상태 업데이트를 위한 페이지 새로고침
                      setState(() {
                        notifications = fetchNotifications();
                      });
                    }
                    // 알림에 따른 페이지 이동 로직 추가...
                      navigateBasedOnCategory(notification.category);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Notification {
  final int notiId;
  final String name;
  final String content;
  final String category;
  final bool isRead;

  Notification({
    required this.notiId,
    required this.name,
    required this.content,
    required this.category,
    required this.isRead,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notiId: json['noti_id'],
      name: json['name'],
      content: json['content'],
      category: json['category'],
      isRead: json['is_read'],
    );
  }
}
