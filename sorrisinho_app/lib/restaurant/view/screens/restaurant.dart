import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/restaurant/view/widgets/menu_day.dart';
import 'package:sorrisinho_app/restaurant/view_model/restaurant.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/shared/widgets/screen_name.dart';

class RestaurantScreen extends StatefulWidget {
  final bool withBackButton;
  const RestaurantScreen({
    super.key,
    required this.withBackButton,
  });

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'restaurant_page_viewed');
    context.read<RestaurantViewModel>().initialLoad();
  }

  @override
  Widget build(BuildContext context) {
    final nextDaysMenusSplittedByDays =
        context.watch<RestaurantViewModel>().nextDaysMenusSplittedByDays;
    final isLoading = context.watch<RestaurantViewModel>().isLoading;

    if (isLoading) {
      return Scaffold(
        backgroundColor: SorrisinhoTheme.primaryColor,
        body: SafeArea(
          child: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.black,
              size: 50,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SorrisinhoTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenNameWidget(
                screenName: 'Cardápio do RU',
                withBackButton: widget.withBackButton,
              ),
              ...nextDaysMenusSplittedByDays.values
                  .map(
                    (menus) => RestaurantMenuDay(
                      menus: menus,
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
