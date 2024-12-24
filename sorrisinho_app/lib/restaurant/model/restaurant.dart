import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sorrisinho_app/classroom/repository/storage.dart';
import 'package:sorrisinho_app/restaurant/models/menu.dart';
import 'package:sorrisinho_app/restaurant/models/menu_rating.dart';
import 'package:sorrisinho_app/restaurant/models/menu_type_enum.dart';
import 'package:sorrisinho_app/restaurant/models/sent_menu_rating.dart';
import 'package:sorrisinho_app/restaurant/repository/restaurant.dart';
import 'package:sorrisinho_app/restaurant/repository/storage.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';

class RestaurantModel extends ChangeNotifier {
  List<RestaurantMenu> _allMenus = [];
  List<RestaurantMenu> _todayMenus = [];
  List<RestaurantMenu> _tomorrowMenus = [];
  List<MenuRating> menuRatings = [];
  List<SentMenuRating> mySentMenuRatings = [];
  Map<DateTime, List<RestaurantMenu>> _nextDaysMenusSplittedByDays = {};
  bool _isLoading = true;
  bool canMakeRestaurantRating = true;
  bool showRatingsWidget = false;

  Future<void> initialLoad() async {
    final savedMenus = await RestaurantStorage().getMenus();

    if (savedMenus.isNotEmpty) {
      _allMenus = (jsonDecode(savedMenus) as List<dynamic>)
          .map((e) => RestaurantMenu.decodeFromStorage(e))
          .toList();
      afterGetValues();
    }

    final sentRatings = await RestaurantStorage().getReviews();

    if (sentRatings.isNotEmpty) {
      mySentMenuRatings = (jsonDecode(sentRatings) as List<dynamic>)
          .map((e) => SentMenuRating.decodeFromStorage(e))
          .toList();

      if (await RestaurantStorage().getShouldSendMenuRatings()) {
        final ra = await ClassRoomStorage().getRa();
        for (var rating in mySentMenuRatings) {
          {
            EventTracker().sendEvent(
              eventName: 'upload_ru_rating',
              eventProps: {
                'ra': ra,
                'date': rating.date.toIso8601String(),
                'type': rating.type.name,
              },
            );
          }

          RestaurantStorage().setShouldSendMenuRatings(false);
        }
      }
    }

    try {
      final response = await RestaurantRepository().fetchAllMenus();
      saveToStorage(response);
      _allMenus = response;
    } catch (_) {}

    _todayMenus = _selectMenusForDate(DateTime.now());
    _tomorrowMenus =
        _selectMenusForDate(DateTime.now().add(const Duration(days: 1)));
    await decideIfShouldShowRatingsWidget();
    decideIfCanMakeReview();
    afterGetValues();
  }

  void decideIfCanMakeReview() {
    final currentType = DateTime.now().hour < 17
        ? RestaurantMenuTypeEnum.lunch
        : RestaurantMenuTypeEnum.dinner;
    canMakeRestaurantRating = mySentMenuRatings
        .where((rating) => rating.type == currentType && isToday(rating.date))
        .isEmpty;
  }

  Future<void> decideIfShouldShowRatingsWidget() async {
    final now = DateTime.now();

    if (now.weekday < 7 &&
        ((now.hour >= 11 && now.hour < 17) ||
            (now.weekday < 6 &&
                (now.hour >= 17 && now.minute >= 30 || now.hour >= 18)))) {
      RestaurantRepository().fetchAllRatings().then((ratings) {
        menuRatings = ratings;
        notifyListeners();
      });
      showRatingsWidget = true;
    } else {
      showRatingsWidget = false;
    }
  }

  Future<void> sendRestaurantReview(int rating, String comment) async {
    final currentType = DateTime.now().hour < 17
        ? RestaurantMenuTypeEnum.lunch
        : RestaurantMenuTypeEnum.dinner;
    final newRating = SentMenuRating(type: currentType, date: DateTime.now());

    mySentMenuRatings.add(newRating);

    await RestaurantStorage().setReviews(jsonEncode(mySentMenuRatings));

    RestaurantRepository()
        .sendReview(rating, comment)
        .then((value) => refresh());
  }

  void refresh() {
    _todayMenus = _selectMenusForDate(DateTime.now());
    _tomorrowMenus =
        _selectMenusForDate(DateTime.now().add(const Duration(days: 1)));
    decideIfShouldShowRatingsWidget();
    decideIfCanMakeReview();
    notifyListeners();
  }

  List<RestaurantMenu> _selectMenusForDate(DateTime date) {
    final allMenus =
        _allMenus.where((menu) => isSameDate(menu.date, date)).toList();

    if (isToday(date) && date.hour >= 17) {
      return allMenus
          .where((menu) => menu.type == RestaurantMenuTypeEnum.dinner)
          .toList();
    }

    return allMenus;
  }

  Future<void> saveToStorage(List<RestaurantMenu> menus) async {
    await RestaurantStorage().setMenus(jsonEncode(menus));
  }

  void afterGetValues() {
    _nextDaysMenusSplittedByDays = _findNextDaysMenusSplittedByDays();
    _isLoading = false;
    notifyListeners();
  }

  Map<DateTime, List<RestaurantMenu>> _findNextDaysMenusSplittedByDays({
    int daysToConsider = 7,
  }) {
    final initialDate = DateTime.now();
    final Map<DateTime, List<RestaurantMenu>> foundMenus = {};

    for (int i = 0; i < daysToConsider; i++) {
      final dateToSearch = initialDate.add(Duration(days: i));
      final menusInThisDate = _allMenus
          .where(
            (menu) => isSameDate(menu.date, dateToSearch),
          )
          .toList();

      if (menusInThisDate.isNotEmpty) {
        foundMenus.addAll(
          Map<DateTime, List<RestaurantMenu>>.from(
            <DateTime, List<RestaurantMenu>>{dateToSearch: menusInThisDate},
          ),
        );
      }
    }

    return foundMenus;
  }

  Map<DateTime, List<RestaurantMenu>> get nextDaysMenusSplittedByDays =>
      _nextDaysMenusSplittedByDays;

  bool get isLoading => _isLoading;

  List<RestaurantMenu> get todayMenus => _todayMenus;

  List<RestaurantMenu> get tomorrowMenus => _tomorrowMenus;
}
