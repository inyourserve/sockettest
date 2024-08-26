import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:sockettest/config/app_config.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal() {
    _initializeWebSocket();
  }

  WebSocketChannel? _channel;
  StreamController<dynamic> _streamController = StreamController.broadcast();
  Function(String)? onConnectionStatusChange;

  void _initializeWebSocket() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('${AppConfig.wsUrl}?token=${AppConfig.token}'),
      );

      onConnectionStatusChange?.call('Connecting');

      _channel!.stream.listen(
        (data) {
          _streamController.add(data);
        },
        onDone: () {
          onConnectionStatusChange?.call('Disconnected');
          _reconnect();
        },
        onError: (error) {
          onConnectionStatusChange?.call('Error: $error');
          _reconnect();
        },
      );

      onConnectionStatusChange?.call('Connected');
    } catch (e) {
      onConnectionStatusChange?.call('Error: ${e.toString()}');
      _reconnect();
    }
  }

  void _reconnect() {
    Future.delayed(Duration(seconds: 5), () {
      _initializeWebSocket();
    });
  }

  Stream<dynamic> get stream => _streamController.stream;

  void send(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    } else {
      print('WebSocket is not connected. Unable to send message.');
    }
  }

  void close() {
    _channel?.sink.close(status.goingAway);
  }
}
