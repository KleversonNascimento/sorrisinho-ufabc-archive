import 'dart:convert';

import 'package:http/http.dart';
import 'package:sorrisinho_app/restaurant/models/menu.dart';
import 'package:sorrisinho_app/restaurant/models/menu_rating.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/urls.dart';

class RestaurantRepository {
  Future<List<RestaurantMenu>> fetchAllMenus() async {
    final response = await get(Uri.parse(Urls.restaurantAllMenus));

    final unformmatedMenus =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    final formmatedMenus = unformmatedMenus
        .map((restaurantMenu) => RestaurantMenu.fromJson(restaurantMenu))
        .toList();

    formmatedMenus.removeWhere((menu) => isPastDate(menu.date));

    formmatedMenus.sort((a, b) => a.date.compareTo(b.date));

    return formmatedMenus;
  }

  Future<List<MenuRating>> fetchAllRatings() async {
    final response = await get(Uri.parse(Urls.restaurantAllRatings));

    final unformmatedRatings =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    final formattedRatings = unformmatedRatings
        .map((restaurantRating) => MenuRating.fromJson(restaurantRating))
        .toList();

    formattedRatings.sort((a, b) => b.date.compareTo(a.date));

    return formattedRatings;
  }

  Future<bool> sendReview(int rating, String comment) async {
    try {
      await post(Uri.parse(Urls.makeRestaurantReview(rating)), body: comment);
      return true;
    } catch (e) {
      return false;
    }
  }
}
