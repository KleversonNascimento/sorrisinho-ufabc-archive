import 'package:sorrisinho_app/calendar/model/calendar.dart';
import 'package:sorrisinho_app/calendar/models/event.dart';

class CalendarViewModel {
  final CalendarModel calendarModel;

  CalendarViewModel({required this.calendarModel});

  Future<void> initialLoad() async {
    return calendarModel.initialLoad();
  }

  List<Event> get allEvents => calendarModel.allEvents;

  bool get isLoading => calendarModel.isLoading;
}
