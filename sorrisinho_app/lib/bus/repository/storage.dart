import 'package:shared_preferences/shared_preferences.dart';

class BusStorage {
  final _busKey = 'bus';

  Future<void> setBus(String bus) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_busKey, bus);
  }

  Future<String> getBus() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_busKey) ?? '';
  }

  Future<void> setLastDeparture(String departure) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString('${_busKey}_departure', departure);
  }

  Future<void> setLastArrival(String arrival) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString('${_busKey}_arrival', arrival);
  }

  Future<String> getLastDeparture() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString('${_busKey}_departure') ?? '';
  }

  Future<String> getLastArrival() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString('${_busKey}_arrival') ?? '';
  }
}
