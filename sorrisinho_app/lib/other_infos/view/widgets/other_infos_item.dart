import 'package:flutter/material.dart';

class OtherInfosItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function() onTap;

  const OtherInfosItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 0,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        size: 24,
                        color: Colors.black,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
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
