import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sockettest/models/job.dart';
import 'package:sockettest/services/websocket_service.dart';

class JobListScreen extends StatefulWidget {
  final WebSocketService webSocketService;

  JobListScreen({required this.webSocketService});

  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  List<Job> _liveJobs = [];
  bool _isOnline = false;
  String? _expandedJobId;

  @override
  void initState() {
    super.initState();
    _listenToWebSocket();
  }

  void _listenToWebSocket() {
    widget.webSocketService.stream.listen((message) {
      try {
        final data = jsonDecode(message);
        print('Received WebSocket message: $data'); // Debug print
        if (data['type'] == 'new_job') {
          setState(() {
            final newJob = Job.fromJson(data['data']);
            print('Parsed new job: $newJob'); // Debug print
            _liveJobs.add(newJob);
          });
        } else if (data['type'] == 'job_details') {
          _updateJobDetails(data['data']);
        }
      } catch (e) {
        print('Error processing WebSocket message: $e');
      }
    });
  }

  void _updateJobDetails(Map<String, dynamic> jobDetails) {
    setState(() {
      final index = _liveJobs.indexWhere((job) => job.id == jobDetails['id']);
      if (index != -1) {
        _liveJobs[index] = Job.fromJson(jobDetails);
      }
    });
  }

  void _applyForJob(String jobId, double bidAmount) {
    widget.webSocketService.send({
      'type': 'apply_for_job',
      'job_id': jobId,
      'bid_amount': bidAmount,
    });
  }

  Widget _buildJobCard(Job job) {
    bool isExpanded = job.id == _expandedJobId;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.work)),
            title: Text(job.subCategory),
            subtitle: Text(job.location),
            trailing: Text(
              '₹${job.hourlyRate.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              setState(() {
                _expandedJobId = isExpanded ? null : job.id;
              });
              if (!isExpanded) {
                widget.webSocketService.send({
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
                  Text('Description: ${job.description ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text('Posted by: ${job.providerName ?? 'N/A'}'),
                  Text(
                      'Provider Rating: ${job.providerRating?.toStringAsFixed(1) ?? 'N/A'} ★'),
                  SizedBox(height: 8),
                  Text(
                      'Distance: ${job.distance?.toStringAsFixed(2) ?? 'N/A'} KM'),
                  SizedBox(height: 16),
                  Text('Bid your Rate/h'),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _applyForJob(job.id, 550),
                        child: Text('₹550'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, onPrimary: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () => _applyForJob(job.id, 600),
                        child: Text('₹600'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, onPrimary: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () => _applyForJob(job.id, 650),
                        child: Text('₹650'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, onPrimary: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle skip
                          },
                          child: Text('Skip'),
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _applyForJob(job.id, job.hourlyRate),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Jobs'),
        actions: [
          IconButton(icon: Icon(Icons.copy), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Offline toggle
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.offline_bolt,
                    color: _isOnline ? Colors.green : Colors.grey),
                SizedBox(width: 8),
                Text(_isOnline ? 'Online' : 'Offline'),
                Switch(
                  value: _isOnline,
                  onChanged: (value) {
                    setState(() {
                      _isOnline = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Map placeholder

          // Job list
          Expanded(
            child: _liveJobs.isEmpty
                ? Center(child: Text('No live jobs available'))
                : ListView.builder(
                    itemCount: _liveJobs.length,
                    itemBuilder: (context, index) =>
                        _buildJobCard(_liveJobs[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
