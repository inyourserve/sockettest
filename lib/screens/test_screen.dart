import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bid Accepted')),
      body: Center(
        child:
            Text('Your bid has been accepted!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
