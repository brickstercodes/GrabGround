import 'package:flutter/material.dart';
import '../../auth/models/chat_message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../services/websocket_service.dart';
import '../models/chat_response.dart';

// StatefulWidget is used because the chat screen needs to maintain state (messages, loading status)
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // WebSocket service to handle real-time communication
  late final WebSocketService _webSocketService;
  // List to store all chat messages
  final List<ChatMessage> _messages = [];
  // Loading indicator state
  bool _isLoading = false;
  // Controller to manage scroll position of the chat list
  final ScrollController _scrollController = ScrollController();
  // Connection status state
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    // Initialize WebSocket connection with a unique user ID
    _webSocketService = WebSocketService(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}');
    _listenToConnection();
    // Start listening for incoming messages
    _listenToResponses();
  }

  void _listenToConnection() {
    _webSocketService.connectionStatus.listen(
      (connected) {
        if (!mounted) return;
        setState(() {
          _isConnected = connected;
          print('Connection status changed to: $connected'); // Debug print
        });
      },
      onError: (error) {
        print('Connection status error: $error'); // Debug print
      },
    );
  }

  @override
  void dispose() {
    // Clean up resources when screen is disposed
    _webSocketService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Set up WebSocket message listener
  void _listenToResponses() {
    _webSocketService.responses.listen(
      (ChatResponse response) {
        if (!mounted) return;
        setState(() {
          _isConnected = true;
          _messages.add(ChatMessage(
            message: response.message,
            isUser: false, // Message is from the other party
            timestamp: response.timestamp,
          ));
          _isLoading = false;

          // Handle similar turfs here if needed
          if (response.similarTurfs.isNotEmpty) {
            // You can show similar turfs in a separate widget
          }
        });
        _scrollToBottom();
      },
      // Handle any errors during WebSocket communication
      onError: (error) {
        print('WebSocket error: $error'); // Debug log
        if (!mounted) return;
        setState(() {
          _isConnected = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: $error')),
        );
      },
    );
  }

  // Handle sending a new message
  void _sendMessage(String message) {
    if (message.trim().isEmpty) return; // Ignore empty messages

    if (!mounted) return;
    setState(() {
      // Add user's message to the list
      _messages.add(ChatMessage(
        message: message,
        isUser: true, // Message is from the current user
        timestamp: DateTime.now(),
      ));
      _isLoading = true; // Show loading indicator while waiting for response
    });

    // Send message through WebSocket
    _webSocketService.sendMessage(message);
    _scrollToBottom();
  }

  // Scroll to the bottom of the chat list
  void _scrollToBottom() {
    if (!mounted) return;
    // Wait for the frame to be rendered before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        elevation: 1,
        actions: [
          // Connection status indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message: _isConnected ? 'Connected' : 'Disconnected',
              child: Icon(
                _isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: _isConnected ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message.message,
                  isUser: message.isUser,
                  timestamp: message.timestamp,
                );
              },
            ),
          ),
          // Loading indicator shown when waiting for response
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          // Message input field
          ChatInput(
            onSend: _sendMessage,
            enabled: !_isLoading, // Disable input while loading
          ),
        ],
      ),
    );
  }
}
