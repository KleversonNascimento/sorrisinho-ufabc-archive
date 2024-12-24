import 'package:flutter/material.dart';
import 'package:sorrisinho_app/restaurant/models/menu.dart';
import 'package:sorrisinho_app/restaurant/models/menu_type_enum.dart';

class MealWidgetHome extends StatefulWidget {
  final RestaurantMenu menu;

  const MealWidgetHome({super.key, required this.menu});

  @override
  State<MealWidgetHome> createState() => _MealWidgetHomeState();
}

class _MealWidgetHomeState extends State<MealWidgetHome> {
  String getTime() {
    if (widget.menu.type == RestaurantMenuTypeEnum.lunch) {
      return '11h às 14h, venda de créditos das 9h às 14h';
    }

    return '17h30 às 20h, venda de créditos das 15h às 20h';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.menu.type == RestaurantMenuTypeEnum.lunch
              ? 'Almoço'
              : 'Jantar',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          getTime(),
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 6),
        ),
        MealItem(title: 'Prato principal', value: widget.menu.principal),
        MealItem(title: 'Opção sem carne', value: widget.menu.vegan),
        MealItem(title: 'Guarnição', value: widget.menu.sideDish),
        MealItem(title: 'Saladas', value: widget.menu.salads),
        MealItem(title: 'Sobremesas', value: widget.menu.desserts),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
        ),
      ],
    );
  }
}

class MealItem extends StatelessWidget {
  final String title;
  final String value;

  const MealItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 20,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 4),
        ),
      ],
    );
  }
}
