import 'package:flutter/material.dart';
import '../models/faq_question.dart';

class FAQAnswerScreen extends StatelessWidget {
  final FAQQuestion question;

  FAQAnswerScreen({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Use'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(question.answer),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Helpful?'),
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    // Implement feedback functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.thumb_down),
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
          child: Text('Contact us'),
          onPressed: () {
            // Implement contact functionality
          },
        ),
      ),
    );
  }
}
