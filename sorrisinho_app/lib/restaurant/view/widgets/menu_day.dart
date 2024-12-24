import 'package:flutter/material.dart';
import 'package:sorrisinho_app/restaurant/models/menu.dart';
import 'package:sorrisinho_app/restaurant/view/widgets/meal.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';

class RestaurantMenuDay extends StatefulWidget {
  final List<RestaurantMenu> menus;

  const RestaurantMenuDay({super.key, required this.menus});

  @override
  State<RestaurantMenuDay> createState() => _RestaurantMenuDayState();
}

class _RestaurantMenuDayState extends State<RestaurantMenuDay> {
  String getTitle(DateTime date) {
    if (isToday(date)) {
      return 'Hoje';
    }

    if (isTomorrow(date)) {
      return 'Amanhã';
    }

    return getWeekdayNameFromNumber(date.weekday);
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.menus.first.date;

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTitle(date),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${date.day}/${date.month}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 6),
          ),
          ...widget.menus.map((menu) => MealWidget(menu: menu)).toList()
        ],
      ),
    );
  }
}
