import 'package:flutter/material.dart';

class EventWidget extends StatelessWidget {
  final int day;
  final String month;
  final String name;
  final String? description;
  final String? link;

  const EventWidget({
    required this.day,
    required this.month,
    required this.name,
    this.description,
    this.link,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsetsDirectional.all(
                  8,
                ),
                child: Column(
                  children: [
                    Text(
                      day.toString().length > 1
                          ? day.toString()
                          : '0${day.toString()}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: const VerticalDivider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsetsDirectional.all(
                    8,
                  ),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
