import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sockettest/models/job.dart';
import 'package:sockettest/services/websocket_service.dart';
import 'package:sockettest/services/bid_service.dart';
import 'package:sockettest/config/app_config.dart';

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late WebSocketService _webSocketService;
  final BidService _bidService = BidService();
  List<Job> _jobs = [];
  String _connectionStatus = 'Connecting to job updates...';
  bool _isOnline = false;
  String? _expandedJobId;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    _webSocketService = WebSocketService(
      onConnectionStatusChange: (status) {
        setState(() {
          _connectionStatus = status;
        });
      },
    );

    _webSocketService.stream.listen(
      (event) {
        final data = jsonDecode(event) as Map<String, dynamic>;
        if (data['type'] == 'new_job') {
          setState(() {
            _jobs.add(Job.fromJson(data['data']));
          });
        } else if (data['type'] == 'job_details') {
          _updateJobDetails(data['data']);
        } else if (data['type'] == 'error') {
          _showError(data['message']);
        }
      },
      onError: (error) {
        _showError('WebSocket error: $error');
      },
    );
  }

  void _updateJobDetails(Map<String, dynamic> jobDetails) {
    setState(() {
      int index = _jobs.indexWhere((job) => job.id == jobDetails['id']);
      if (index != -1) {
        _jobs[index] = Job.fromJson(jobDetails);
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: $message'),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> _placeBid(String jobId, double amount) async {
    try {
      final result = await _bidService.placeBid(jobId, amount);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Bid placed successfully!'),
          backgroundColor: Colors.green,
        ));
        setState(() {
          _expandedJobId = null;
        });
      } else {
        _showError('Failed to place bid. Please try again.');
      }
    } catch (e) {
      _showError('An error occurred while placing the bid: $e');
    }
  }

  Widget _buildJobCard(Job job) {
    bool isExpanded = job.id == _expandedJobId;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.work)),
            title: Text(job.subCategory),
            subtitle: Text(job.location),
            trailing: Text(
              '₹${job.hourlyRate}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              setState(() {
                _expandedJobId = isExpanded ? null : job.id;
              });
              if (!isExpanded) {
                _webSocketService.send({
                  'type': 'get_job_details',
                  'job_id': job.id,
                });
              }
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Provider: ${job.providerName ?? 'N/A'}'),
                  Text('Rating: ${job.providerRating ?? 'N/A'} ★'),
                  SizedBox(height: 8),
                  Text('Description: ${job.description ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text('Distance: ${job.distance ?? 'N/A'} KM'),
                  SizedBox(height: 16),
                  Text('Bid your Rate/h'),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBidButton(job.id, 550),
                      _buildBidButton(job.id, 600),
                      _buildBidButton(job.id, 650),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _expandedJobId = null;
                            });
                          },
                          child: Text('Skip'),
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _placeBid(job.id, job.hourlyRate),
                          child: Text('Apply'),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBidButton(String jobId, int rate) {
    return ElevatedButton(
      onPressed: () => _placeBid(jobId, rate.toDouble()),
      child: Text('₹$rate'),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        side: BorderSide(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find new job'),
        actions: [
          IconButton(icon: Icon(Icons.copy), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.offline_bolt, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: TextStyle(color: Colors.grey),
                ),
                Switch(
                  value: _isOnline,
                  onChanged: (value) {
                    setState(() {
                      _isOnline = value;
                    });
                    // You might want to add logic here to connect/disconnect from the WebSocket
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(_connectionStatus),
          ),
          Expanded(
            child: _jobs.isEmpty
                ? Center(child: Text('No jobs available'))
                : ListView.builder(
                    itemCount: _jobs.length,
                    itemBuilder: (context, index) {
                      return _buildJobCard(_jobs[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'New Job'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rating'),
        ],
        onTap: (index) {
          // Add navigation logic here
        },
      ),
    );
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }
}
