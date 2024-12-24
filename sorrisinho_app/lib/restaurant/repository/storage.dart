import 'package:shared_preferences/shared_preferences.dart';

class RestaurantStorage {
  final _restaurantMenusKey = 'restaurant_menus';
  final _restaurantReviewsKey = 'restaurant_reviews';
  final _restaurantReviewsSendKey = 'restaurant_reviews_send';

  Future<void> setMenus(String menus) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_restaurantMenusKey, menus);
  }

  Future<String> getMenus() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_restaurantMenusKey) ?? '';
  }

  Future<void> setReviews(String reviews) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_restaurantReviewsKey, reviews);
  }

  Future<String> getReviews() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_restaurantReviewsKey) ?? '';
  }

  Future<void> setShouldSendMenuRatings(bool value) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setBool(_restaurantReviewsSendKey, value);
  }

  Future<bool> getShouldSendMenuRatings() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getBool(_restaurantReviewsSendKey) ?? true;
  }
}
