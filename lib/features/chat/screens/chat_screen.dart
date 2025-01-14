import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/chat_response.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../services/websocket_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final WebSocketService _wsService;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _wsService =
        WebSocketService(userId: 'user123'); // Replace with actual user ID
    _listenToResponses();
  }

  void _listenToResponses() {
    _wsService.responses.listen(
      (response) {
        setState(() {
          _messages.add(ChatMessage(
            message: response.message,
            isUser: false,
          ));
          _isLoading = false;
        });
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: $error')),
        );
        setState(() => _isLoading = false);
      },
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        message: text,
        isUser: true,
      ));
      _isLoading = true;
    });

    _wsService.sendMessage(text).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $error')),
      );
    });
  }

  @override
  void dispose() {
    _wsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with TurfAdvisor')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  ChatBubble(message: _messages[index]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ChatInput(onSubmitted: _handleSubmitted),
        ],
      ),
    );
  }
}
