import 'package:sorrisinho_app/bus/model/bus.dart';
import 'package:sorrisinho_app/bus/models/bus_trip.dart';
import 'package:sorrisinho_app/classroom/model/classroom.dart';
import 'package:sorrisinho_app/classroom/models/classroom.dart';
import 'package:sorrisinho_app/classroom/models/nois_resolve.dart';
import 'package:sorrisinho_app/restaurant/model/restaurant.dart';
import 'package:sorrisinho_app/restaurant/models/menu.dart';
import 'package:sorrisinho_app/restaurant/models/menu_rating.dart';
import 'package:sorrisinho_app/tab_bar/model/tab_bar.dart';

class HomeViewModel {
  final ClassRoomModel classRoomModel;
  final BusModel busModel;
  final RestaurantModel restaurantModel;
  final TabBarModel tabBarModel;

  HomeViewModel({
    required this.classRoomModel,
    required this.busModel,
    required this.restaurantModel,
    required this.tabBarModel,
  });

  Future<void> initialLoad() async {
    classRoomModel.initialLoad();
    busModel.initialLoad();
    restaurantModel.initialLoad();
  }

  Future<void> refresh() async {
    busModel.refresh();
    restaurantModel.refresh();
    classRoomModel.refresh();
  }

  List<ClassRoom> get todayClasses => classRoomModel.todayClasses;

  List<ClassRoom> get tomorrowClasses => classRoomModel.tomorrowClasses;

  List<RestaurantMenu> get todayMenus => restaurantModel.todayMenus;

  List<RestaurantMenu> get tomorrowMenus => restaurantModel.tomorrowMenus;

  bool get showRestaurantRatingsWidget => restaurantModel.showRatingsWidget;

  List<MenuRating> get menuRatings => restaurantModel.menuRatings;

  List<BusTrip> get selectedBusTrips => busModel.selectedBusTrips;

  DateTime get selectedDateForBusTrips => busModel.selectedDate;

  BusTrip? get lastBusTrip => busModel.lastBusTrip;

  void changeSelectedDate(DateTime date) => busModel.changeSelectedDate(date);

  List<String> get availableArrivals => busModel.availableArrivals;

  List<String> get availableDepartures => busModel.availableDepartures;

  String get selectedArrival => busModel.selectedArrival;

  String get selectedDeparture => busModel.selectedDeparture;

  void changeArrival(String arrival) => busModel.changeArrival(arrival);

  void changDeparture(String departure) => busModel.changeDeparture(departure);

  void changeSelectedScreen(int index) =>
      tabBarModel.changeSelectedIndex(index);

  Future<void> sendRestaurantReview(int rating, String comment) =>
      restaurantModel.sendRestaurantReview(rating, comment);

  List<ClassRoom> get remainingTodayClasses =>
      classRoomModel.remainingTodayClasses;

  bool get isLoading => classRoomModel.isLoading || busModel.isLoading;

  bool get canMakeRestaurantRating => restaurantModel.canMakeRestaurantRating;

  bool get showTheNewsAd => classRoomModel.showTheNewsAd;

  NoisResolve get noisResolve => classRoomModel.noisResolve;
}
