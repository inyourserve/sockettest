import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:sockettest/config/app_config.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  WebSocketService._internal();

  WebSocketChannel? _channel;
  StreamController<dynamic> _streamController = StreamController.broadcast();
  Function(String)? onConnectionStatusChange;
  BuildContext? _context;

  void initialize(BuildContext context) {
    _context = context;
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('${AppConfig.wsUrl}?token=${AppConfig.token}'),
      );

      onConnectionStatusChange?.call('Connecting');

      _channel!.stream.listen(
        (data) {
          _streamController.add(data);
          _handleIncomingMessage(data);
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

  void _handleIncomingMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      print('Received WebSocket message: $data'); // Debug print
      if (data['type'] == 'bid_status_update' &&
          data['data']['status'] == 'accepted') {
        _navigateToTestScreen();
      }
    } catch (e) {
      print('Error processing WebSocket message: $e');
    }
  }

  void _navigateToTestScreen() {
    if (_context != null) {
      Navigator.of(_context!).pushNamed('/test_screen');
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

  void disconnect() {
    _channel?.sink.close(status.goingAway);
  }

  void dispose() {
    _channel?.sink.close();
    _streamController.close();
  }
}
