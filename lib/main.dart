import 'package:flutter/material.dart';
import 'package:sockettest/screens/job_list_screen.dart';
import 'package:sockettest/screens/provider_screen.dart';
import 'package:sockettest/screens/test_screen.dart';
import 'package:sockettest/services/websocket_service.dart';
import 'package:sockettest/screens/faq_category_screen.dart'; // Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WebSocketService _webSocketService = WebSocketService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          _webSocketService.initialize(context);
          return MainScreen();
        },
      ),
      routes: {
        '/test_screen': (context) => TestScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final String _jobId =
      '66ccad95c4a2b58cecf1d27f'; // Replace with actual job ID when available

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          JobListScreen(webSocketService: WebSocketService()),
          ProviderScreen(jobId: _jobId, webSocketService: WebSocketService()),
          FAQCategoriesScreen(), // Add this line
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Provider',
          ),
          BottomNavigationBarItem(
            // Add this item
            icon: Icon(Icons.help),
            label: 'FAQ',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
