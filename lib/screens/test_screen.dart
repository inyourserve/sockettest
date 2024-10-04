import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bid Accepted')),
      body: const Center(
        child:
            Text('Your bid has been accepted!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
