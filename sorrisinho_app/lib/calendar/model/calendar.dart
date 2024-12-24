import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sorrisinho_app/calendar/models/event.dart';
import 'package:sorrisinho_app/calendar/repository/calendar.dart';
import 'package:sorrisinho_app/calendar/repository/storage.dart';

class CalendarModel extends ChangeNotifier {
  List<Event> _allEvents = [];
  var _isLoading = true;

  Future<void> initialLoad() async {
    final savedEvents = await CalendarStorage().getEvents();

    if (savedEvents.isNotEmpty) {
      _allEvents = (jsonDecode(savedEvents) as List<dynamic>)
          .map((e) => Event.decodeFromStorage(e))
          .toList();
      afterGetValues();
    }

    final response = await CalendarRepository().fetchAllDates();
    saveToStorage(response);
    _allEvents = response;
    afterGetValues();
  }

  Future<void> saveToStorage(List<Event> events) async {
    await CalendarStorage().setEvents(jsonEncode(events));
  }

  void afterGetValues() {
    _isLoading = false;
    notifyListeners();
  }

  List<Event> get allEvents => _allEvents;

  bool get isLoading => _isLoading;
}
