import 'package:sorrisinho_app/shared/bus_frequency_enum.dart';

class BusTrip {
  final String departure;
  final Duration departureTime;
  final String arrival;
  final Duration arrivalTime;
  final int lineNumber;
  final BusFrequency frequency;

  const BusTrip({
    required this.departure,
    required this.departureTime,
    required this.arrival,
    required this.arrivalTime,
    required this.lineNumber,
    required this.frequency,
  });

  factory BusTrip.fromJson(Map<String, dynamic> json) {
    final departureTimeSplitted = json['departureTime'].toString().split(':');
    final arrivalTimeSplitted = json['arrivalTime'].toString().split(':');

    return BusTrip(
      departure: json['departure'],
      departureTime: Duration(
        hours: int.parse(departureTimeSplitted[0]),
        minutes: int.parse(departureTimeSplitted[1]),
      ),
      arrival: json['arrival'],
      arrivalTime: Duration(
        hours: int.parse(arrivalTimeSplitted[0]),
        minutes: int.parse(arrivalTimeSplitted[1]),
      ),
      lineNumber: json['lineNumber'],
      frequency: json['frequency'].toString() == 'SATURDAY'
          ? BusFrequency.saturday
          : BusFrequency.businessDay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departure': departure,
      'departureTime': departureTime.toString(),
      'arrival': arrival,
      'arrivalTime': arrivalTime.toString(),
      'lineNumber': lineNumber.toString(),
      'frequency': frequency.toString(),
    };
  }

  factory BusTrip.decodeFromStorage(dynamic storageValue) {
    final departureTimeSplitted =
        storageValue['departureTime'].toString().split(':');
    final arrivalTimeSplitted =
        storageValue['arrivalTime'].toString().split(':');

    return BusTrip(
      departure: storageValue['departure'],
      departureTime: Duration(
        hours: int.parse(departureTimeSplitted[0]),
        minutes: int.parse(departureTimeSplitted[1]),
      ),
      arrival: storageValue['arrival'],
      arrivalTime: Duration(
        hours: int.parse(arrivalTimeSplitted[0]),
        minutes: int.parse(arrivalTimeSplitted[1]),
      ),
      lineNumber: int.parse(storageValue['lineNumber']),
      frequency: storageValue['frequency'].toString() == 'saturday'
          ? BusFrequency.saturday
          : BusFrequency.businessDay,
    );
  }
}
