class Job {
  final String id;
  final String subCategory;
  final String location;
  final double hourlyRate;
  final String? providerName;
  final double? providerRating;
  final String? description;
  final double? distance;

  Job({
    required this.id,
    required this.subCategory,
    required this.location,
    required this.hourlyRate,
    this.providerName,
    this.providerRating,
    this.description,
    this.distance,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      subCategory: json['sub_category'],
      location: json['location'],
      hourlyRate: json['hourly_rate'].toDouble(),
      providerName: json['provider_name'],
      providerRating: json['provider_rating']?.toDouble(),
      description: json['description'],
      distance: json['distance']?.toDouble(),
    );
  }
}
