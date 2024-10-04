import 'package:flutter/material.dart';
import '../models/faq_question.dart';
import '../services/faq_service.dart';
import 'faq_answer_screen.dart';

class FAQQuestionsScreen extends StatefulWidget {
  final String categoryId;

  const FAQQuestionsScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _FAQQuestionsScreenState createState() => _FAQQuestionsScreenState();
}

class _FAQQuestionsScreenState extends State<FAQQuestionsScreen> {
  final FAQService _faqService = FAQService();
  late Future<List<FAQQuestion>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _faqService.getFAQQuestions(widget.categoryId);
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
      body: FutureBuilder<List<FAQQuestion>>(
        future: _questions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FAQQuestion question = snapshot.data![index];
                return ListTile(
                  title: Text(question.question),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FAQAnswerScreen(question: question),
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
