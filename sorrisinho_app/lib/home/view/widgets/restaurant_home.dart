import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_star_rating/simple_star_rating.dart';
import 'package:sorrisinho_app/home/view/widgets/meal_widget_home.dart';
import 'package:sorrisinho_app/home/view_model/home.dart';
import 'package:sorrisinho_app/restaurant/models/menu.dart';
import 'package:sorrisinho_app/restaurant/view/screens/menu_ratings.dart';
import 'package:sorrisinho_app/restaurant/view/screens/restaurant.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/theme.dart';

class RestaurantHomeWidget extends StatelessWidget {
  final List<RestaurantMenu> todayMenus;
  final List<RestaurantMenu> tomorrowMenus;

  const RestaurantHomeWidget({
    super.key,
    required this.todayMenus,
    required this.tomorrowMenus,
  });

  @override
  Widget build(BuildContext context) {
    final selectedMenus = todayMenus.isEmpty ? tomorrowMenus : todayMenus;
    final date = selectedMenus.first.date;

    final showRatingsWidget =
        context.watch<HomeViewModel>().showRestaurantRatingsWidget;
    final canMakeRestaurantRating =
        context.watch<HomeViewModel>().canMakeRestaurantRating;

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              width: MediaQuery.of(context).size.width - 48,
              child: Text(
                'RU - ${getTitle(date)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...selectedMenus
                      .map((menu) => MealWidgetHome(menu: menu))
                      .toList()
                ],
              ),
            ),
            showRatingsWidget ? const RatingsWidget() : const SizedBox.shrink(),
            (showRatingsWidget && canMakeRestaurantRating)
                ? const MakeReviewWidget()
                : const SizedBox.shrink(),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RestaurantScreen(
                          withBackButton: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                    child: const Text(
                      'Ver todos os cardápios >',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RatingsWidget extends StatelessWidget {
  const RatingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final menuRatings = context.watch<HomeViewModel>().menuRatings;
    final ratingsWithComments =
        menuRatings.where((rating) => rating.comment != null).toList();
    double average = 2.5;
    if (menuRatings.isNotEmpty) {
      average = menuRatings
              .map((rating) => rating.rating)
              .fold(0.0, (prev, amount) => prev + amount) /
          menuRatings.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
          child: Text(
            'Avaliação do ${getMealType()} de hoje',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: SorrisinhoTheme.informationBackgroundColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Text(
            average.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 38,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Text(
            menuRatings.length > 1
                ? 'Nota baseada em ${menuRatings.length} avaliações'
                : 'Nota baseada em ${menuRatings.length} avaliação',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuRatingsScreen(
                  withBackButton: true,
                  menuRatings: ratingsWithComments,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 4),
            child: Text(
              ratingsWithComments.length <= 1
                  ? 'Abrir ${ratingsWithComments.length} comentário'
                  : 'Abrir ${ratingsWithComments.length} comentários',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: SorrisinhoTheme.informationBackgroundColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MakeReviewWidget extends StatefulWidget {
  const MakeReviewWidget({
    super.key,
  });

  @override
  State<MakeReviewWidget> createState() => _MakeReviewWidgetState();
}

class _MakeReviewWidgetState extends State<MakeReviewWidget> {
  late TextEditingController _restaurantCommentController;
  double selectedRating = 3;

  @override
  void initState() {
    super.initState();
    _restaurantCommentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
          child: const Text(
            'Faça a sua avaliação',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 8),
          child: SimpleStarRating(
            allowHalfRating: false,
            starCount: 5,
            rating: selectedRating,
            size: 32,
            isReadOnly: false,
            onRated: (double? rating) {
              setState(() {
                selectedRating = rating!;
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: const Text(
            'Comentário (opcional)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: TextField(
            controller: _restaurantCommentController,
            keyboardType: TextInputType.multiline,
            maxLength: 140,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              helperStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
          child: ElevatedButton(
            onPressed: () async {
              context.read<HomeViewModel>().sendRestaurantReview(
                    selectedRating.toInt(),
                    _restaurantCommentController.text,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SorrisinhoTheme.primaryColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero),
              ),
            ),
            child: const Text(
              'Enviar avaliação',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String getMealType() {
  if (DateTime.now().hour < 17) {
    return 'almoço';
  }

  return 'jantar';
}

String getTitle(DateTime date) {
  if (isToday(date)) {
    return 'hoje';
  }

  if (isTomorrow(date)) {
    return 'amanhã';
  }

  return getWeekdayNameFromNumber(date.weekday);
}
