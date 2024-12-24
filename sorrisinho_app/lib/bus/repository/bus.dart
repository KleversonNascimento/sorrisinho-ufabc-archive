import 'dart:convert';

import 'package:http/http.dart';
import 'package:sorrisinho_app/bus/models/bus_trip.dart';
import 'package:sorrisinho_app/shared/urls.dart';

class BusRepository {
  Future<List<BusTrip>> fetchAllTrips() async {
    final response = await get(Uri.parse(Urls.busAllTrips));

    final unformmatedTrips =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    final formmatedTrips =
        unformmatedTrips.map((busTrip) => BusTrip.fromJson(busTrip)).toList();

    return formmatedTrips;
  }
}
