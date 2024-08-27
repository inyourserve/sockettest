import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/faq_category.dart';
import '../models/faq_question.dart';

class FAQService {
  final String baseUrl = 'http://127.0.0.1:8000/api/v1';

  Future<List<FAQCategory>> getFAQCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/faq/categories'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FAQCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load FAQ categories');
    }
  }

  Future<List<FAQQuestion>> getFAQQuestions(String categoryId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/faq/questions?category_id=$categoryId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FAQQuestion.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load FAQ questions');
    }
  }
}
