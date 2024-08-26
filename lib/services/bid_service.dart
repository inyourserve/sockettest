import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sockettest/config/app_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BidService {
  Future<bool> placeBid(String jobId, double amount) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/api/v1/bids');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AppConfig.token}',
    };
    final body = jsonEncode({
      'job_id': jobId,
      'amount': amount,
    });

    try {
      http.Response response;
      if (kIsWeb) {
        // For web, use a standard http.post request
        response = await http.post(url, headers: headers, body: body);
      } else {
        // For native platforms, create a client to handle potential certificate issues
        final client = http.Client();
        try {
          response = await client.post(url, headers: headers, body: body);
        } finally {
          client.close();
        }
      }

      if (response.statusCode == 200) {
        print('Bid placed successfully');
        return true;
      } else {
        print('Error placing bid: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception when placing bid: $e');
      return false;
    }
  }
}
