import 'package:shared_preferences/shared_preferences.dart';

class CalendarStorage {
  final _calendarEventsKey = 'calendar_events';

  Future<void> setEvents(String events) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_calendarEventsKey, events);
  }

  Future<String> getEvents() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_calendarEventsKey) ?? '';
  }
}
