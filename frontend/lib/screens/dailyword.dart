import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/screens/chat_page/chat_page.dart';
import 'package:get/get.dart';

final dioInstance = dio.Dio();

Future<Map<String, dynamic>> getDailyWord() async {
  dio.Response response;
  response = await dioInstance.get('${baseURL}fastapi/dailyword');

  print(response.data.toString());

  return response.data; // hello world
}

class DailyWord extends StatelessWidget {
  const DailyWord({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일일 단어'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: getDailyWord(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.data!['word']}',
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.data!['response']}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(() => const ChatPage());
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Chat Bot에게 질문하기'),
                            SizedBox(width: 16),
                            Icon(Icons.chat),
                          ],
                        ))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
