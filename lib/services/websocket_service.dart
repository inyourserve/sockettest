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
  final StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();
  Function(String)? onConnectionStatusChange;
  bool _hasListener = false;
  int _connectionCount = 0;
  String _currentConnectionId = '';

  void initialize() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    if (_channel != null) {
      print('WebSocket already initialized. Skipping re-initialization.');
      return;
    }

    try {
      String wsUrl = '${AppConfig.wsUrl}?token=${AppConfig.token}';
      _connectionCount++;
      _currentConnectionId = 'conn_$_connectionCount';
      print(
          'Connecting to WebSocket URL: $wsUrl (Connection ID: $_currentConnectionId)');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      onConnectionStatusChange?.call('Connecting');

      if (!_hasListener) {
        _channel!.stream.listen(
          (data) {
            final decodedData = jsonDecode(data);
            _streamController.add({
              'connectionId': _currentConnectionId,
              'data': decodedData,
            });
          },
          onDone: () {
            onConnectionStatusChange?.call('Disconnected');
            print(
                'WebSocket disconnected (Connection ID: $_currentConnectionId)');
            _reconnect();
          },
          onError: (error) {
            onConnectionStatusChange?.call('Error: $error');
            print(
                'WebSocket connection error: $error (Connection ID: $_currentConnectionId)');
            _reconnect();
          },
        );
        _hasListener = true;
      }

      onConnectionStatusChange?.call('Connected');
      print(
          'WebSocket connected successfully (Connection ID: $_currentConnectionId)');
    } catch (e) {
      onConnectionStatusChange?.call('Error: ${e.toString()}');
      print(
          'Error initializing WebSocket: ${e.toString()} (Connection ID: $_currentConnectionId)');
      _reconnect();
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      print(
          'Attempting to reconnect WebSocket... (Previous Connection ID: $_currentConnectionId)');
      _initializeWebSocket();
    });
  }

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void send(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
      print(
          'Sent WebSocket message on connection $_currentConnectionId: $message');
    } else {
      print(
          'WebSocket is not connected. Unable to send message. (Connection ID: $_currentConnectionId)');
    }
  }

  void disconnect() {
    if (_channel != null) {
      print(
          'Disconnecting WebSocket... (Connection ID: $_currentConnectionId)');
      _channel?.sink.close(status.goingAway);
      _channel = null;
      _hasListener = false;
    }
  }

  void dispose() {
    print(
        'Disposing WebSocketService... (Connection ID: $_currentConnectionId)');
    _channel?.sink.close();
    _streamController.close();
  }
}
