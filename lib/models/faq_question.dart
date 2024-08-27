class FAQQuestion {
  final String id;
  final String categoryId;
  final String question;
  final String answer;

  FAQQuestion({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.answer,
  });

  factory FAQQuestion.fromJson(Map<String, dynamic> json) {
    return FAQQuestion(
      id: json['_id'],
      categoryId: json['category_id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}
