import 'package:flutter/material.dart';
import '../models/faq_question.dart';

class FAQAnswerScreen extends StatelessWidget {
  final FAQQuestion question;

  const FAQAnswerScreen({Key? key, required this.question}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(question.answer),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Helpful?'),
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    // Implement feedback functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () {
                    // Implement feedback functionality
                  },
                ),
              ],
            ),
          ],
        ),
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
