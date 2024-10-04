import 'package:flutter/material.dart';
import 'package:sockettest/models/job.dart';
import 'package:sockettest/services/websocket_service.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);

  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final List<Job> _liveJobs = [];
  bool _isOnline = false;
  String? _expandedJobId;
  final WebSocketService _webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    _listenToWebSocket();
  }

  void _listenToWebSocket() {
    _webSocketService.stream.listen((message) {
      final connectionId = message['connectionId'] as String;
      final data = message['data'] as Map<String, dynamic>;
      print('Received WebSocket message on connection $connectionId: $data');

      if (data['type'] == 'new_job') {
        _handleNewJob(data['data'] as Map<String, dynamic>, connectionId);
      } else if (data['type'] == 'job_details') {
        _updateJobDetails(data['data'] as Map<String, dynamic>, connectionId);
      } else if (data['type'] == 'error') {
        _handleError(data['message'] as String, connectionId);
      } else if (data['type'] == 'ping') {
        print('Received ping on connection $connectionId');
      }
    });
  }

  void _handleNewJob(Map<String, dynamic> jobData, String connectionId) {
    final newJob = Job.fromJson(jobData);
    setState(() {
      if (!_liveJobs.any((job) => job.id == newJob.id)) {
        _liveJobs.add(newJob);
        print('Added new job: ${newJob.id} (Connection: $connectionId)');
      } else {
        print(
            'Received duplicate job: ${newJob.id} (Connection: $connectionId) - Not adding');
      }
    });
  }

  void _updateJobDetails(Map<String, dynamic> jobDetails, String connectionId) {
    setState(() {
      final index = _liveJobs.indexWhere((job) => job.id == jobDetails['id']);
      if (index != -1) {
        _liveJobs[index] = Job.fromJson(jobDetails);
        print(
            'Updated job details for job: ${jobDetails['id']} (Connection: $connectionId)');
      } else {
        print(
            'Job ${jobDetails['id']} not found for updating details (Connection: $connectionId)');
      }
    });
  }

  void _handleError(String errorMessage, String connectionId) {
    print('Error from server on connection $connectionId: $errorMessage');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $errorMessage')),
    );
  }

  void _applyForJob(String jobId, double bidAmount) {
    _webSocketService.send({
      'type': 'apply_job',
      'job_id': jobId,
      'bid_amount': bidAmount,
    });
  }

  Widget _buildJobCard(Job job) {
    bool isExpanded = job.id == _expandedJobId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.work)),
            title: Text(job.subCategory),
            subtitle: Text(job.location),
            trailing: Text(
              '₹${job.hourlyRate.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Text('Description: ${job.description ?? 'N/A'}'),
                  const SizedBox(height: 8),
                  Text('Posted by: ${job.providerName ?? 'N/A'}'),
                  Text(
                      'Provider Rating: ${job.providerRating?.toStringAsFixed(1) ?? 'N/A'} ★'),
                  const SizedBox(height: 8),
                  Text(
                      'Distance: ${job.distance?.toStringAsFixed(2) ?? 'N/A'} KM'),
                  const SizedBox(height: 16),
                  const Text('Bid your Rate/h'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _applyForJob(job.id, 550),
                        child: const Text('₹550'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () => _applyForJob(job.id, 600),
                        child: const Text('₹600'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () => _applyForJob(job.id, 650),
                        child: const Text('₹650'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle skip
                          },
                          child: const Text('Skip'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _applyForJob(job.id, job.hourlyRate),
                          child: const Text('Apply'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
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
        title: const Text('Live Jobs'),
        actions: [
          IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.offline_bolt,
                    color: _isOnline ? Colors.green : Colors.grey),
                const SizedBox(width: 8),
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
          Expanded(
            child: _liveJobs.isEmpty
                ? const Center(child: Text('No live jobs available'))
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

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }
}
