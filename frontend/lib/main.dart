import 'package:flutter/material.dart';
import 'package:frontend/models/user/user_controller.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message title : ${message.notification?.title}");
  print("Handling a background message body : ${message.notification?.body}");
}

String? globalFCMToken;

void registerNotification(String token) async {
  final DatabaseReference database = FirebaseDatabase.instance.reference();

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

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

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'high_importance_channel', 'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'item x');

    // 받은 알림 출력
    print("Received notification title: ${message.notification?.title}");
    print("Received notification: ${message.notification?.body}");
  });

  Get.put(UserController());
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
      // home: FutureBuilder(
      //   future: _authService.tryAutoLogin(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     } else {
      //       if (snapshot.data == true) {
      //         return PinLoginPage();
      //       } else {
      //         return LoginPage();
      //       }
      //     }
      //   },
      // ),
      home: FutureBuilder<LoginResult>(
        future: _authService.tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!.isSuccess) {
            // 로그인 성공 시 PIN 로그인 페이지로 이동
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
