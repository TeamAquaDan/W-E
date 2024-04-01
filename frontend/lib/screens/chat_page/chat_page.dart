import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/api/test_html.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  Future<String> postChatBot(String userInput) async {
    debugPrint('postChatBot');
    Response response;
    // response = await dio.get('${baseURL}fastapi/dailyword');
    response = await dio
        .post('${baseURL}fastapi/chatbot', data: {'user_input': userInput});

    print(response.data.toString());

    return response.data['response'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('챗봇 페이지'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(
                  message: message.text,
                  isBotMessage: message.isBotMessage,
                  timestamp: message.timestamp,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '챗봇과 대화를 시작하세요!',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      messages.add(
                        Message(
                          text: _controller.text,
                          isBotMessage: false,
                          timestamp: '10:00 AM',
                        ),
                      );
                    });
                    String res = await postChatBot(_controller.text);
                    setState(() {
                      messages.add(
                        Message(
                          text: res,
                          isBotMessage: true,
                          timestamp: '10:00 AM',
                        ),
                      );
                    });
                    // _controller.clear();
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isBotMessage;
  final String timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isBotMessage,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      alignment: isBotMessage ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment:
            isBotMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isBotMessage ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timestamp,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isBotMessage;
  final String timestamp;

  Message({
    required this.text,
    required this.isBotMessage,
    required this.timestamp,
  });
}

List<Message> messages = [
  Message(
    text: 'Hello, how can I assist you?',
    isBotMessage: true,
    timestamp: '10:00 AM',
  ),
  Message(
    text: 'I need help with my order.',
    isBotMessage: false,
    timestamp: '10:05 AM',
  ),
  // Add more messages here
];
