import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Send message logic
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

  const ChatBubble({super.key, 
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
