import 'package:flutter/material.dart';

class ScreenNameWidget extends StatelessWidget {
  final String screenName;
  final Widget? rightIcon;
  final Widget? leftIcon;
  final bool withBackButton;

  const ScreenNameWidget({
    super.key,
    required this.screenName,
    this.rightIcon,
    this.leftIcon,
    this.withBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (leftIcon != null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftIcon != null ? leftIcon! : const SizedBox.shrink(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: withBackButton
                        ? Container(
                            margin: const EdgeInsets.only(
                              bottom: 4,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 32,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: Text(
                      screenName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              rightIcon != null ? rightIcon! : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: withBackButton
                      ? Container(
                          margin: const EdgeInsets.only(
                            bottom: 4,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 32,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: Text(
                    screenName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            rightIcon != null ? rightIcon! : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
