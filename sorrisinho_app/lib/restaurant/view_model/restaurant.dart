import 'package:sorrisinho_app/restaurant/model/restaurant.dart';
import 'package:sorrisinho_app/restaurant/models/menu.dart';

class RestaurantViewModel {
  final RestaurantModel restaurantModel;

  RestaurantViewModel({required this.restaurantModel});

  Future<void> initialLoad() async {
    restaurantModel.initialLoad();
  }

  Map<DateTime, List<RestaurantMenu>> get nextDaysMenusSplittedByDays =>
      restaurantModel.nextDaysMenusSplittedByDays;

  bool get isLoading => restaurantModel.isLoading;
}
