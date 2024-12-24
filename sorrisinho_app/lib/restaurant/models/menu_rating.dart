class MenuRating {
  final String? comment;
  final int rating;
  final DateTime date;

  const MenuRating({
    required this.comment,
    required this.rating,
    required this.date,
  });

  factory MenuRating.fromJson(Map<String, dynamic> json) {
    return MenuRating(
      comment: json['comment'],
      rating: json['rating'],
      date: DateTime.parse(
        json['createdAt'],
      ),
    );
  }
}
