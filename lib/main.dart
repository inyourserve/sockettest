import 'package:flutter/material.dart';
import 'package:sockettest/screens/job_list_screen.dart';
import 'package:sockettest/screens/provider_screen.dart';
import 'package:sockettest/services/websocket_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WebSocketService webSocketService = WebSocketService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(webSocketService: webSocketService),
    );
  }
}

class MainScreen extends StatefulWidget {
  final WebSocketService webSocketService;

  MainScreen({required this.webSocketService});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.webSocketService.onConnectionStatusChange = (status) {
      print('WebSocket connection status: $status');
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          JobListScreen(webSocketService: widget.webSocketService),
          ProviderScreen(
            jobId: '66ccad95c4a2b58cecf1d27f',
            webSocketService: widget.webSocketService,
          ),
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
