// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:sockettest/models/bid.dart';
// import 'package:sockettest/services/websocket_service.dart';

// class ProviderScreen extends StatefulWidget {
//   final String jobId;
//   final WebSocketService webSocketService;

//   const ProviderScreen(
//       {Key? key, required this.jobId, required this.webSocketService})
//       : super(key: key);

//   @override
//   _ProviderScreenState createState() => _ProviderScreenState();
// }

// class _ProviderScreenState extends State<ProviderScreen> {
//   final List<Bid> _liveBids = [];

//   @override
//   void initState() {
//     super.initState();
//     _listenToWebSocket();
//   }

//   void _listenToWebSocket() {
//     widget.webSocketService.stream.listen((message) {
//       try {
//         final data = jsonDecode(message);
//         print('Received WebSocket message: $data'); // Debug print
//         if (data['type'] == 'new_bid') {
//           setState(() {
//             final newBid = Bid.fromJson(data['data']);
//             print('Parsed new bid: $newBid'); // Debug print
//             _liveBids.add(newBid);
//           });
//         } else if (data['type'] == 'bid_status_update') {
//           _updateBidStatus(data['data']);
//         }
//       } catch (e) {
//         print('Error processing WebSocket message: $e');
//       }
//     });
//   }

//   void _updateBidStatus(Map<String, dynamic> data) {
//     setState(() {
//       final index = _liveBids.indexWhere((bid) => bid.id == data['bid_id']);
//       if (index != -1) {
//         final updatedBid = Bid.fromJson({
//           ..._liveBids[index].toJson(),
//           'status': data['status'],
//         });
//         _liveBids[index] = updatedBid;
//       }
//     });
//   }

//   void _acceptBid(String bidId) {
//     widget.webSocketService.send({
//       'type': 'accept_bid',
//       'bid_id': bidId,
//       'job_id': widget.jobId,
//     });
//   }

//   Widget _buildBidCard(Bid bid) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(bid.seekerName,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     Text(bid.seekerCategory,
//                         style:
//                             const TextStyle(fontSize: 14, color: Colors.grey)),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text('₹${bid.amount}',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     Text('${bid.estimatedTime} min',
//                         style:
//                             const TextStyle(fontSize: 14, color: Colors.grey)),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.star, color: Colors.amber, size: 16),
//                     Text(
//                         ' ${bid.starRating.toStringAsFixed(1)} (${bid.totalRatings})'),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle decline
//                       },
//                       child: const Text('Decline'),
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: bid.status != 'accepted'
//                           ? () => _acceptBid(bid.id)
//                           : null,
//                       child: Text(
//                           bid.status == 'accepted' ? 'Accepted' : 'Accept'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: bid.status == 'accepted'
//                             ? Colors.green.shade300
//                             : Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Live Bids for Job'),
//       ),
//       body: _liveBids.isEmpty
//           ? const Center(child: Text('No live bids available'))
//           : ListView.builder(
//               itemCount: _liveBids.length,
//               itemBuilder: (context, index) => _buildBidCard(_liveBids[index]),
//             ),
//     );
//   }
// }
