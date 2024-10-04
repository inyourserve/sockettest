// lib/config/app_config.dart

class AppConfig {
  static const String apiBaseUrl = 'http://139.59.59.53:8000';
  static const String wsUrl = 'ws://139.59.59.53:8000/ws';
  static const String apiUrl = 'http://139.59.59.53:8000/api/v1';

  // Hardcoded token (Note: This is not recommended for production use)
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjZmYjMzNWJjZTRkNDIzOGJlZDkyZTI1IiwibW9iaWxlIjoiOTE3MzIwOTgwNjgwIiwicm9sZXMiOlsic2Vla2VyIiwicHJvdmlkZXIiXSwiZXhwIjoxNzMwNDk0Nzg4fQ.EtALXNJR_nAKiWDKsHH50VOo__YJ-tTD2sGD8B7-74M';

  // Method to get the full WebSocket URL with the token
  static String get fullWsUrl {
    return '$wsUrl?token=$token';
  }

  // Add other configuration constants as needed
}
