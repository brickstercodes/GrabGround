import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';
import '../models/chat_response.dart';

class WebSocketService {
  final _logger = Logger();
  static WebSocketService? _instance;
  WebSocketChannel? _channel;
  final String userId;
  final _responseController =
      StreamController<Map<String, dynamic>>.broadcast();
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  int _retryCount = 0;
  static const int _maxRetries = 5;

  // Add connection status stream
  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  factory WebSocketService({required String userId}) {
    _instance ??= WebSocketService._internal(userId);
    return _instance!;
  }

  WebSocketService._internal(this.userId) {
    _connect();
  }

  Stream<ChatResponse> get responses => _responseController.stream.map((json) {
        try {
          return ChatResponse.fromJson(json);
        } catch (e) {
          _logger.e('Error converting response to ChatResponse: $e');
          rethrow;
        }
      });

  String _getWebSocketUrl() {
    final host = Platform.isAndroid
        ? '10.0.2.2'
        : Platform.isIOS
            ? 'localhost'
            : '127.0.0.1';
    return 'ws://$host:8000/ws/$userId';
  }

  Future<void> _connect() async {
    if (_isConnecting) return;
    _isConnecting = true;
    _connectionStatusController.add(false);

    try {
      final wsUrl = _getWebSocketUrl();
      _logger.d('Attempting to connect to WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
      );

      bool receivedFirstMessage = false;

      _channel?.stream.listen(
        (data) {
          _logger.d('Raw WebSocket data received: $data');
          try {
            if (data == null) {
              _logger.w('Received null data from WebSocket');
              return;
            }
            final jsonData = jsonDecode(data.toString());
            _logger.d('Parsed WebSocket data: $jsonData');
            if (!receivedFirstMessage) {
              receivedFirstMessage = true;
              _connectionStatusController.add(true);
              _logger.i('WebSocket connection confirmed with first message');
            }

            _retryCount = 0;
            _responseController.add(jsonData);
          } catch (e) {
            _logger.e('Error parsing WebSocket data: $e');
            _handleError('Failed to parse message: $e');
          }
        },
        onError: _handleError,
        onDone: () {
          _logger.w('WebSocket connection closed');
          _connectionStatusController.add(false);
          _handleDisconnect();
        },
        cancelOnError: false,
      );

      // Send initial ping after connection
      Timer(const Duration(seconds: 1), () {
        if (!receivedFirstMessage) {
          _handleError('No initial response received');
        }
      });
    } catch (e) {
      _logger.e('WebSocket connection error: $e');
      _handleError(e);
    } finally {
      _isConnecting = false;
    }
  }

  void _handleError(dynamic error) {
    _logger.e('WebSocket error: $error');
    if (!_responseController.isClosed) {
      _responseController.addError(error);
    }
    _handleDisconnect();
  }

  void _handleDisconnect() {
    if (_retryCount < _maxRetries) {
      _retryCount++;
      final backoff = Duration(seconds: _retryCount * 2);
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(backoff, _connect);
    }
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _responseController.close();
    _connectionStatusController.close();
    _instance = null;
  }

  void sendMessage(String message) {
    try {
      if (_channel == null) {
        _logger.w('WebSocket channel is null');
        _connect();
        return;
      }
      _logger.d('Sending message: $message');
      _channel?.sink.add(jsonEncode({
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      }));
    } catch (e) {
      _logger.e('Error sending message: $e');
    }
  }
}
