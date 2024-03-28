// import 'package:flutter/material.dart';
// import 'package:frontend/models/user/user_controller.dart';
// import 'package:frontend/services/auth_service.dart';
// import 'package:frontend/screens/login_page.dart';
// import 'package:frontend/screens/pin_login_page.dart';
// import 'package:get/get.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'firebase_options.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_database/firebase_database.dart';

// import 'screens/alarm_page.dart';
// import 'screens/child_page/child_page.dart';
// import 'screens/friends_page/my_friends_page.dart';
// import 'screens/mission_page/my_mission_page.dart';
// import 'screens/pin_setting_page.dart';
// import 'screens/profile_page/my_profile_page.dart';
// import 'screens/salary_page/salary_list_page.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print("Handling a background message title : ${message.notification?.title}");
//   print("Handling a background message body : ${message.notification?.body}");
//   if (message.data.containsKey('category')) {
//     print("Background message category: ${message.data['category']}");
//   }
// }

// String? globalFCMToken;

// void registerNotification(String token) async {
//   final DatabaseReference database = FirebaseDatabase.instance.ref();

//   try {
//     // 알림 데이터 저장
//     await database
//         .child('notifications')
//         .push()
//         .set({'token': token, 'message': '새로운 알림이 있습니다!'});
//   } catch (e) {
//     print("Error saving token to database: $e");
//   }
// }

// void handleNotificationClick(RemoteMessage? message) {
//   if (message != null && isLoggedIn) {
//     final category = message.data['category'];
//     if (category != null) {
//       switch (category) {
//         case '100':
//           Get.offAll(() => const MyFriendsPage());
//           break;
//         case '400':
//           Get.offAll(() => const SalaryListPage());
//           break;
//         case '600':
//           Get.offAll(() => const MyProfilePage());
//           break;
//         default:
//           Get.offAll(() => const AlarmPage());
//           break;
//       }
//     }
//   }
// }

// // void handleNotificationClick(RemoteMessage message) {
// //   String payload = message.data['category'];
// //   handleNotificationPayload(payload);
// // }

// // payload 기반 페이지 이동 처리 함수
// void handleNotificationPayload(String payload) {
//   // Get.to()를 사용하여 페이지 이동
//   if (payload == '100') {
//     Get.to(() => const AlarmPage());
//   } else if (payload == '400') {
//     Get.to(() => const SalaryListPage());
//   } else if (payload == '600') {
//     Get.to(() => const MyProfilePage());
//   } else {
//     Get.to(() => const AlarmPage());
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

//   // 앱이 시작될 때 초기 알림 메시지 처리
//   // final initialMessage = await firebaseMessaging.getInitialMessage();
//   // if (initialMessage != null) {
//   //   handleNotificationClick(initialMessage);
//   // }

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     handleNotificationClick(message);
//   });

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   final token = await firebaseMessaging.getToken(
//       vapidKey:
//           "BE7iYFjUuyLa43iOM8c_yA4k7Qq_OSLuftREbtlmUTW1dn8_xup7LBmT2XLZj52eT-S8j6st4yXKZ_Vub7jtxNU");
//   print('Token: $token');
//   if (token != null) {
//     globalFCMToken = token;
//     registerNotification(token);
//   }

//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // 알림 설정
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('ic_launcher');
//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   /// 새로운 콜백 함수 사용
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//     if (response.payload != null) {
//       // 알림을 클릭했을 때 필요한 작업을 수행합니다.
//       handleNotificationPayload(response.payload!);
//     }
//   });

//   // Notification Channel 설정
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   // Foreground 알림 메시지 처리
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     // 알림 디테일 설정
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             'high_importance_channel', 'High Importance Notifications',
//             channelDescription:
//                 'This channel is used for important notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: 'ic_launcher',
//             ticker: 'ticker');

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     // 알림 표시
//     await flutterLocalNotificationsPlugin.show(
//         message.hashCode,
//         message.notification?.title,
//         message.notification?.body,
//         notificationDetails,
//         payload: message.data['category']);

//     // 받은 알림 출력
//     print("Received notification title: ${message.notification?.title}");
//     print("Received notification: ${message.notification?.body}");
//     if (message.data.containsKey('category')) {
//       print("Foreground message category: ${message.data['category']}");
//     }
//   });
//   // GetX 컨트롤러 초기화
//   Get.put(UserController());
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final AuthService _authService = AuthService();

//   MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Auth',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F62DE)),
//         primarySwatch: Colors.blue,
//         // 텍스트 필드의 스타일을 정의합니다.
//         inputDecorationTheme: const InputDecorationTheme(
//           labelStyle: TextStyle(fontSize: 20), // labelText의 크기를 크게 설정합니다.
//           border: OutlineInputBorder(), // 외곽에 테두리를 추가합니다.
//           // 추가적으로 테두리의 스타일이나 색상을 조정할 수 있습니다.
//           // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2.0)),
//           contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         ),
//       ),
//       // home: FutureBuilder(
//       //   future: _authService.tryAutoLogin(),
//       //   builder: (context, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.waiting) {
//       //       return const CircularProgressIndicator();
//       //     } else {
//       //       if (snapshot.data == true) {
//       //         return PinLoginPage();
//       //       } else {
//       //         return LoginPage();
//       //       }
//       //     }
//       //   },
//       // ),
//       home: FutureBuilder<LoginResult>(
//         future: _authService.tryAutoLogin(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.hasData && snapshot.data!.isSuccess) {
//             // MyApp 위젯의 빌드가 완료되면, 초기 알림 클릭 처리를 진행
//             WidgetsBinding.instance.addPostFrameCallback((_) async {
//               RemoteMessage? initialMessage =
//                   await FirebaseMessaging.instance.getInitialMessage();
//               if (initialMessage != null) {
//                 handleNotificationClick(initialMessage);
//               }
//             });
//             // // 로그인 성공 시 PIN 로그인 페이지로 이동
//             // Future.delayed(Duration.zero, () async {
//             //   // 알림 데이터에 따른 처리 로직
//             //   RemoteMessage? initialMessage =
//             //       await FirebaseMessaging.instance.getInitialMessage();
//             //   if (initialMessage != null)
//             //     handleNotificationClick(initialMessage);
//             // });
//             return const PinLoginPage();
//           } else {
//             // 로그인 실패 또는 로그인 정보 없음 -> 로그인 페이지로 이동
//             return const LoginPage();
//           }
//         },
//       ),

//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('ko', ''),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend/models/store/account/account_controller.dart';
import 'package:frontend/models/store/saving_goal/goal_list_controller.dart';
import 'package:frontend/models/store/user/user_controller.dart';
import 'package:frontend/models/store/userRole/user_role.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/screens/login_page.dart';
import 'package:frontend/screens/pin_login_page.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'screens/alarm_page.dart';
import 'screens/child_page/child_page.dart';
import 'screens/friends_page/my_friends_page.dart';
import 'screens/mission_page/my_mission_page.dart';
import 'screens/pin_setting_page.dart';
import 'screens/profile_page/my_profile_page.dart';
import 'screens/salary_page/salary_list_page.dart';
import 'package:frontend/services/auth_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message title : ${message.notification?.title}");
  print("Handling a background message body : ${message.notification?.body}");
  if (message.data.containsKey('category')) {
    print("Background message category: ${message.data['category']}");
  }
}

String? globalFCMToken;

void registerNotification(String token) async {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  try {
    // 알림 데이터 저장
    await database
        .child('notifications')
        .push()
        .set({'token': token, 'message': '새로운 알림이 있습니다!'});
  } catch (e) {
    print("Error saving token to database: $e");
  }
}

void handleNotificationClick(RemoteMessage? message, bool isLoggedIn) {
  if (message != null && isLoggedIn) {
    final category = message.data['category'];
    if (category != null) {
      switch (category) {
        case '100':
          Get.offAll(() => const MyFriendsPage());
          break;
        case '400':
          Get.offAll(() => const SalaryListPage());
          break;
        case '600':
          Get.offAll(() => const MyProfilePage());
          break;
        default:
          Get.offAll(() => const AlarmPage());
          break;
      }
    }
  }
}

// void handleNotificationClick(RemoteMessage message) {
//   String payload = message.data['category'];
//   handleNotificationPayload(payload);
// }

// payload 기반 페이지 이동 처리 함수
void handleNotificationPayload(String payload) {
  // Get.to()를 사용하여 페이지 이동
  if (payload == '100') {
    Get.to(() => const AlarmPage());
  } else if (payload == '400') {
    Get.to(() => const SalaryListPage());
  } else if (payload == '600') {
    Get.to(() => const MyProfilePage());
  } else {
    Get.to(() => const AlarmPage());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // 앱이 시작될 때 초기 알림 메시지 처리
  // final initialMessage = await firebaseMessaging.getInitialMessage();
  // if (initialMessage != null) {
  //   handleNotificationClick(initialMessage);
  // }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    String payload = message.data['category'];
    handleNotificationPayload(payload);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final token = await firebaseMessaging.getToken(
      vapidKey:
          "BE7iYFjUuyLa43iOM8c_yA4k7Qq_OSLuftREbtlmUTW1dn8_xup7LBmT2XLZj52eT-S8j6st4yXKZ_Vub7jtxNU");
  print('Token: $token');
  if (token != null) {
    globalFCMToken = token;
    registerNotification(token);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 알림 설정
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  /// 새로운 콜백 함수 사용
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
    if (response.payload != null) {
      // 알림을 클릭했을 때 필요한 작업을 수행합니다.
      handleNotificationPayload(response.payload!);
    }
  });

  // Notification Channel 설정
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Foreground 알림 메시지 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // 알림 디테일 설정
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'high_importance_channel', 'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_launcher',
            ticker: 'ticker');

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // 알림 표시
    await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data['category']);

    // 받은 알림 출력
    print("Received notification title: ${message.notification?.title}");
    print("Received notification: ${message.notification?.body}");
    if (message.data.containsKey('category')) {
      print("Foreground message category: ${message.data['category']}");
    }
  });
  // GetX 컨트롤러 초기화
  Get.put(UserController());
  Get.put(AccountController());
  Get.put(UserRoleController());
  Get.put(GoalListController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F62DE)),
        primarySwatch: Colors.blue,
        // 텍스트 필드의 스타일을 정의합니다.
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 20), // labelText의 크기를 크게 설정합니다.
          border: OutlineInputBorder(), // 외곽에 테두리를 추가합니다.
          // 추가적으로 테두리의 스타일이나 색상을 조정할 수 있습니다.
          // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2.0)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
      home: FutureBuilder<LoginResult>(
        future: _authService.tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!.isSuccess) {
            // MyApp 위젯의 빌드가 완료되면, 초기 알림 클릭 처리를 진행
            // WidgetsBinding.instance.addPostFrameCallback((_) async {
            //   RemoteMessage? initialMessage =
            //       await FirebaseMessaging.instance.getInitialMessage();
            //   if (initialMessage != null) {
            //     handleNotificationClick(initialMessage, true);
            //   }
            // });
            // // 로그인 성공 시 PIN 로그인 페이지로 이동
            // Future.delayed(Duration.zero, () async {
            //   // 알림 데이터에 따른 처리 로직
            //   RemoteMessage? initialMessage =
            //       await FirebaseMessaging.instance.getInitialMessage();
            //   if (initialMessage != null)
            //     handleNotificationClick(initialMessage);
            // });
            return const PinLoginPage();
          } else {
            // 로그인 실패 또는 로그인 정보 없음 -> 로그인 페이지로 이동
            return const LoginPage();
          }
        },
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
      ],
    );
  }
}
