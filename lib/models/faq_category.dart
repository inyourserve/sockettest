class FAQCategory {
  final String id;
  final String name;
  final String role;

  FAQCategory({required this.id, required this.name, required this.role});

  factory FAQCategory.fromJson(Map<String, dynamic> json) {
    return FAQCategory(
      id: json['_id'],
      name: json['name'],
      role: json['role'],
    );
  }
}
