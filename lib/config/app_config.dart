// lib/config/app_config.dart

class AppConfig {
  static const String apiBaseUrl = 'http://127.0.0.1:8000';
  static const String wsUrl = 'ws://127.0.0.1:8000/ws';

  // Hardcoded token (Note: This is not recommended for production use)
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjZiYjAzMjdiY2NhOTMxMzUxYzMxNDhlIiwibW9iaWxlIjoiOTE5NTIzMzUzMzY1Iiwicm9sZXMiOlsicHJvdmlkZXIiLCJzZWVrZXIiXSwiZXhwIjoxNzI0NzUyNDUzfQ.cyvvM2ifb-1qIJQpAi38t4hxhu5tX9UMMrQnY-Hm6Bg';

  // Method to get the full WebSocket URL with the token
  static String get fullWsUrl {
    return '$wsUrl?token=$token';
  }

  // Add other configuration constants as needed
}
