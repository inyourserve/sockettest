import 'package:flutter/material.dart';
import 'package:sockettest/screens/job_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Seeker Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JobListScreen(),
    );
  }
}
