import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/base_profile_url.dart';
import 'package:frontend/api/base_url.dart';
import 'package:frontend/api/test_html.dart';
import 'package:frontend/widgets/my_img.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  Future<String> postChatBot(String userInput) async {
    debugPrint('postChatBot 인풋: $userInput');
    Response response;
    // response = await dio.get('${baseURL}fastapi/dailyword');
    response = await dio
        .post('${baseURL}fastapi/chatbot', data: {'user_input': userInput});

    print(response.data.toString());

    return response.data['response'];
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('W-E Bot'),
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
                  // timestamp: message.timestamp,
                );
              },
            ),
          ),
          _isLoading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('답변을 생각하고 있어요!'),
                    SizedBox(width: 8),
                    CircularProgressIndicator(),
                  ],
                )
              : Container(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 270,
                  height: 40,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 24), // 텍스트 왼쪽 패딩
                      filled: true, // 배경색을 채우기 위해 필요
                      fillColor: Color(0xFFF4F6FA), // 배경색 설정
                      hintText: '궁금한 것을 물어보세요!', // 힌트 텍스트 설정
                      hintStyle: const TextStyle(
                        // 힌트 텍스트 스타일 설정
                        color: Color.fromARGB(255, 97, 97, 97),
                        fontSize: 13,
                        fontFamily: 'Aggro',
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        // 테두리 설정
                        borderRadius: BorderRadius.circular(16), // 테두리 반경 설정
                        borderSide: BorderSide(
                          // 테두리 색상 및 두께 설정
                          color: Colors.black.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      String userInput = _controller.text;
                      _controller.text = '';
                      setState(() {
                        messages.add(
                          Message(
                            text: userInput,
                            isBotMessage: false,
                            // timestamp: '10:00 AM',
                          ),
                        );
                        _isLoading = true;
                      });
                      String res = await postChatBot(userInput);
                      setState(() {
                        messages.add(
                          Message(
                            text: res,
                            isBotMessage: true,
                            // timestamp: '10:00 AM',
                          ),
                        );
                        _isLoading = false;
                      });
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF568EF8)), // 배경색 설정
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        // 테두리 반경 설정
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white, // 아이콘 색상을 하얀색으로 변경
                    ),
                  ),
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
  // final String timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isBotMessage,
    // required this.timestamp,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isBotMessage
                  ? CircleAvatar(
                      child: ClipOval(
                          child: Image.network(
                        '${baseProfileURL}',
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      )),
                    )
                  : Container(),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color:
                        isBotMessage ? Colors.white : const Color(0xFF568EF8),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF568EF8)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isBotMessage ? const Color(0xFF568EF8) : Colors.white,
                    ),
                  ),
                ),
              ),
              isBotMessage ? Container() : MyProfileIcon(),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isBotMessage;
  // final String timestamp;

  Message({
    required this.text,
    required this.isBotMessage,
    // required this.timestamp,
  });
}

List<Message> messages = [
  Message(
    text: '안녕하세요! 궁금한 점을 알려드릴게요!',
    isBotMessage: true,
    // timestamp: '10:00 AM',
  ),
  // Message(
  //   text: 'I need help with my order.',
  //   isBotMessage: false,
  //   // timestamp: '10:05 AM',
  // ),
  // Add more messages here
];
