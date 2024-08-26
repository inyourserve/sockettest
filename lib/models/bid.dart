class Bid {
  final String id;
  final String jobId;
  final String seekerId;
  final String seekerName;
  final String seekerCategory;
  final double amount;
  final String status;
  final double starRating;
  final int totalRatings;
  final int estimatedTime;

  Bid({
    required this.id,
    required this.jobId,
    required this.seekerId,
    required this.seekerName,
    required this.seekerCategory,
    required this.amount,
    required this.status,
    required this.starRating,
    required this.totalRatings,
    required this.estimatedTime,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] ?? '',
      jobId: json['job_id'] ?? '',
      seekerId: json['seeker_id'] ?? '',
      seekerName: json['seeker_name'] ?? 'Unknown',
      seekerCategory: json['seeker_category_name'] ?? 'Unknown Category',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      starRating: (json['average_rating'] ?? 0).toDouble(),
      totalRatings: json['total_reviews'] ?? 0,
      estimatedTime: json['estimated_time'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'seeker_id': seekerId,
      'amount': amount,
      'status': status,
      'estimated_time': estimatedTime,
    };
  }
}
