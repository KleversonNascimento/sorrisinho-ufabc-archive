import 'package:sorrisinho_app/restaurant/models/menu_type_enum.dart';

class SentMenuRating {
  final RestaurantMenuTypeEnum type;
  final DateTime date;

  const SentMenuRating({
    required this.type,
    required this.date,
  });

  factory SentMenuRating.fromJson(Map<String, dynamic> json) {
    return SentMenuRating(
      type: json['type'] == 'dinner'
          ? RestaurantMenuTypeEnum.dinner
          : RestaurantMenuTypeEnum.lunch,
      date: DateTime.parse(
        json['date'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'date': date.toIso8601String(),
    };
  }

  factory SentMenuRating.decodeFromStorage(dynamic storageValue) {
    return SentMenuRating(
      type: storageValue['type'] == 'dinner'
          ? RestaurantMenuTypeEnum.dinner
          : RestaurantMenuTypeEnum.lunch,
      date: DateTime.parse(
        storageValue['date'],
      ),
    );
  }
}
