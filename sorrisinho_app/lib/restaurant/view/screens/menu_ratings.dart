import 'package:flutter/material.dart';
import 'package:sorrisinho_app/restaurant/models/menu_rating.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/shared/widgets/screen_name.dart';

class MenuRatingsScreen extends StatefulWidget {
  final bool withBackButton;
  final List<MenuRating> menuRatings;

  const MenuRatingsScreen({
    super.key,
    required this.withBackButton,
    required this.menuRatings,
  });

  @override
  State<MenuRatingsScreen> createState() => _MenuRatingsScreenState();
}

class _MenuRatingsScreenState extends State<MenuRatingsScreen> {
  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'restaurant_ratings_page_viewed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SorrisinhoTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenNameWidget(
                screenName: 'Avaliações do RU',
                withBackButton: widget.withBackButton,
              ),
              ...widget.menuRatings
                  .map(
                    (menuRating) => MenuRatingWidget(
                      menuRating: menuRating,
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

class MenuRatingWidget extends StatelessWidget {
  final MenuRating menuRating;
  const MenuRatingWidget({super.key, required this.menuRating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Container(
          margin: const EdgeInsets.all(8),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${menuRating.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      menuRating.rating == 1 ? 'estrela' : 'estrelas',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${menuRating.comment}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
