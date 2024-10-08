import 'package:flutter/material.dart';
import '../models/faq_category.dart';
import '../services/faq_service.dart';
import 'faq_question_screen.dart';

class FAQCategoriesScreen extends StatefulWidget {
  const FAQCategoriesScreen({Key? key}) : super(key: key);

  @override
  _FAQCategoriesScreenState createState() => _FAQCategoriesScreenState();
}

class _FAQCategoriesScreenState extends State<FAQCategoriesScreen> {
  final FAQService _faqService = FAQService();
  late Future<List<FAQCategory>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _faqService.getFAQCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<FAQCategory>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No FAQ categories found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FAQCategory category = snapshot.data![index];
                return ListTile(
                  title: Text(category.name),
                  subtitle: const Text('Know how to create account, OTP'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FAQQuestionsScreen(categoryId: category.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: const Text('Contact us'),
          onPressed: () {
            // Implement contact functionality
          },
        ),
      ),
    );
  }
}
