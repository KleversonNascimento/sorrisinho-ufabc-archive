import 'package:flutter/material.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:url_launcher/url_launcher.dart';

class TheNewsWidget extends StatefulWidget {
  const TheNewsWidget({super.key});

  @override
  State<TheNewsWidget> createState() => _TheNewsWidgetState();
}

class _TheNewsWidgetState extends State<TheNewsWidget> {
  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'the_news_ad_page_viewed');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: GestureDetector(
        onTap: () async {
          EventTracker().sendEvent(eventName: 'the_news_ad_click');
          await launchUrl(
            Uri.parse('https://thenewscc.beehiiv.com/subscribe?ref=zSmNxYWwPf'),
            mode: LaunchMode.externalApplication,
          );
        },
        child: Material(
          elevation: 8,
          color: const Color.fromARGB(255, 255, 207, 0),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(8, 4, 4, 8),
                child: Column(
                  children: const [
                    Text(
                      '☕',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      'the news',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    children: const [
                      Text(
                        'ler notícias com o the news é tão fácil quanto saber sua sala pelo sorrisinho. toque aqui e assine a newsletter, é totalmente grátis!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
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
