import 'dart:convert';

import 'package:http/http.dart';
import 'package:sorrisinho_app/calendar/models/event.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/urls.dart';

class CalendarRepository {
  Future<List<Event>> fetchAllDates() async {
    final response = await get(Uri.parse(Urls.calendarAllDates));

    final unformmatedEvents =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    final formmatedEvents =
        unformmatedEvents.map((event) => Event.fromJson(event)).toList();

    formmatedEvents.removeWhere((event) => isPastDate(event.date));

    formmatedEvents.sort((a, b) => a.date.compareTo(b.date));

    return formmatedEvents;
  }
}
