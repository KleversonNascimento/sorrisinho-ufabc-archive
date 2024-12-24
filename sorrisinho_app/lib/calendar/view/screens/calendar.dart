import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/calendar/view/widget/event.dart';
import 'package:sorrisinho_app/calendar/view_model/calendar.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/shared/widgets/screen_name.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'calendar_page_viewed');
    context.read<CalendarViewModel>().initialLoad();
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<CalendarViewModel>().allEvents;
    final isLoading = context.watch<CalendarViewModel>().isLoading;

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
              const ScreenNameWidget(screenName: 'Calendário'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events
                    .map(
                      (event) => EventWidget(
                        day: event.date.day,
                        month:
                            parseMonthNumberToStringAcronym(event.date.month),
                        name: event.name,
                        description: event.description,
                        link: event.link,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
