import 'package:sorrisinho_app/shared/bus_frequency_enum.dart';
import 'package:sorrisinho_app/shared/current_biweekly_enum.dart';

bool isSameDate(DateTime firstDate, DateTime secondDate) =>
    firstDate.day == secondDate.day &&
    firstDate.month == secondDate.month &&
    firstDate.year == secondDate.year;

bool isToday(DateTime date) {
  final DateTime today = DateTime.now();

  return isSameDate(date, today);
}

bool isTomorrow(DateTime date) {
  final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

  return isSameDate(date, tomorrow);
}

BusFrequency busFrequencyByDate(DateTime date) {
  if (date.weekday == DateTime.sunday) {
    return BusFrequency.sunday;
  }

  if (date.weekday == DateTime.saturday) {
    return BusFrequency.saturday;
  }

  return BusFrequency.businessDay;
}

int weeksBetween(DateTime from, DateTime to) {
  from = DateTime.utc(from.year, from.month, from.day);
  to = DateTime.utc(to.year, to.month, to.day);
  return (to.difference(from).inDays / 7).ceil();
}

int findWeekNumber({DateTime? date}) {
  date ??= DateTime.now();
  final firstJan = DateTime(2023, 12, 31); // first sunday of the year
  final result = weeksBetween(firstJan, date);

  if (date.weekday == DateTime.sunday) {
    return result + 1;
  }

  return result;
}

CurrentBiweekly findCurrentBiweekly({DateTime? date}) =>
    findWeekNumber(date: date) % 2 != 0
        ? CurrentBiweekly.two
        : CurrentBiweekly.one;

bool isNotToday(DateTime date) => !isToday(date);

bool isPastDate(DateTime date) =>
    date.isBefore(DateTime.now()) && isNotToday(date);

String getWeekdayNameFromNumber(int number) =>
    parseWeekdayNumberToText[number] ?? '';

Map<int, String> parseWeekdayNumberToText = {
  1: 'Segunda-feira',
  2: 'Terça-feira',
  3: 'Quarta-feira',
  4: 'Quinta-feira',
  5: 'Sexta-feira',
  6: 'Sábado',
  7: 'Domingo'
};

String parseMonthNumberToStringAcronym(int monthNumber) =>
    monthNumberToStringAcronym[monthNumber] ?? '';

Map<int, String> monthNumberToStringAcronym = {
  1: 'jan',
  2: 'fev',
  3: 'mar',
  4: 'abr',
  5: 'mai',
  6: 'jun',
  7: 'jul',
  8: 'ago',
  9: 'set',
  10: 'out',
  11: 'nov',
  12: 'dez',
};
