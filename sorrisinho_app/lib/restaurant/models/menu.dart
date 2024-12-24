import 'package:sorrisinho_app/restaurant/models/menu_type_enum.dart';

class RestaurantMenu {
  final RestaurantMenuTypeEnum type;
  final String principal;
  final String vegan;
  final String sideDish;
  final String salads;
  final String desserts;
  final DateTime date;

  const RestaurantMenu({
    required this.type,
    required this.principal,
    required this.vegan,
    required this.sideDish,
    required this.salads,
    required this.desserts,
    required this.date,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      type: json['type'] == 'dinner'
          ? RestaurantMenuTypeEnum.dinner
          : RestaurantMenuTypeEnum.lunch,
      principal: json['principal'],
      vegan: json['vegan'],
      date: DateTime.parse(
        json['date'],
      ),
      sideDish: json['sideDish'],
      salads: json['salads'],
      desserts: json['desserts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'principal': principal,
      'vegan': vegan,
      'sideDish': sideDish,
      'salads': salads,
      'desserts': desserts,
      'date': date.toIso8601String(),
    };
  }

  factory RestaurantMenu.decodeFromStorage(dynamic storageValue) {
    return RestaurantMenu(
      type: storageValue['type'] == 'dinner'
          ? RestaurantMenuTypeEnum.dinner
          : RestaurantMenuTypeEnum.lunch,
      principal: storageValue['principal'],
      vegan: storageValue['vegan'],
      date: DateTime.parse(
        storageValue['date'],
      ),
      sideDish: storageValue['sideDish'],
      salads: storageValue['salads'],
      desserts: storageValue['desserts'],
    );
  }
}
