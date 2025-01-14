import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../config/env_config.dart';
import '../models/chat_response.dart';

class WebSocketService {
  final String _wsUrl = EnvConfig.websocketUrl; // Use environment config
  late final WebSocketChannel _channel;
  final String _userId;

  WebSocketService({required String userId}) : _userId = userId {
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
  }

  Stream<ChatResponse> get responses => _channel.stream.map((event) {
        final data = jsonDecode(event as String);
        if (data['error'] != null) {
          throw Exception(data['error']);
        }
        return ChatResponse.fromJson(data);
      }).handleError((error) {
        print('WebSocket error: $error');
        _reconnect();
        throw error;
      });

  void _reconnect() {
    _channel.sink.close(status.goingAway);
    _connect();
  }

  Future<void> sendMessage(String content) async {
    try {
      _channel.sink.add(jsonEncode({
        'content': content,
        'user_id': _userId,
        'timestamp': DateTime.now().toIso8601String(),
      }));
    } catch (e) {
      print('Send message error: $e');
      throw Exception('Failed to send message');
    }
  }

  void dispose() {
    _channel.sink.close(status.goingAway);
  }
}
