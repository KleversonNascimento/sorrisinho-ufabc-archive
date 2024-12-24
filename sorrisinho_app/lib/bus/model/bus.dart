import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sorrisinho_app/bus/models/bus_trip.dart';
import 'package:sorrisinho_app/bus/repository/bus.dart';
import 'package:sorrisinho_app/bus/repository/storage.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';

class BusModel extends ChangeNotifier {
  List<BusTrip> _allBusTrips = [];
  List<BusTrip> _availableBusTrips = [];
  List<BusTrip> _selectedBusTrips = [];
  List<String> availableDepartures = [];
  BusTrip? lastBusTrip;
  String selectedDeparture = '';
  List<String> availableArrivals = [];
  String selectedArrival = '';
  DateTime selectedDate = DateTime.now();
  var _isLoading = true;

  Future<void> initialLoad() async {
    final savedBusTrips = await BusStorage().getBus();

    if (savedBusTrips.isNotEmpty) {
      _allBusTrips = (jsonDecode(savedBusTrips) as List<dynamic>)
          .map((e) => BusTrip.decodeFromStorage(e))
          .toList();
      afterGetValues();
    }

    try {
      final response = await BusRepository().fetchAllTrips();
      response.sort(
        (a, b) =>
            a.departureTime.inMinutes.compareTo(b.departureTime.inMinutes),
      );
      _allBusTrips = response;
      saveToStorage(response);
    } catch (_) {}

    selectedDeparture = await BusStorage().getLastDeparture();
    selectedArrival = await BusStorage().getLastArrival();
    _filterTrips();
    afterGetValues();
  }

  void refresh() {
    selectedDate = isToday(selectedDate) ? DateTime.now() : selectedDate;
    _filterTrips();
    notifyListeners();
  }

  void _filterTrips() {
    _availableBusTrips = filterBusTripsByDate(selectedDate);
    availableDepartures = findAvailableDepartures();
    selectedDeparture = availableDepartures.contains(selectedDeparture)
        ? selectedDeparture
        : availableDepartures.isNotEmpty
            ? availableDepartures.first
            : 'Santo André';
    availableArrivals = findAvailableArrivals();
    selectedArrival = availableArrivals.contains(selectedArrival)
        ? selectedArrival
        : availableArrivals.isNotEmpty
            ? availableArrivals[0]
            : 'São Bernardo';
    BusStorage().setLastDeparture(selectedDeparture);
    BusStorage().setLastArrival(selectedArrival);
    filterSelectedBusTrips();
    findLastBusTrip();
  }

  void changeSelectedDate(DateTime date) {
    selectedDate = isToday(date) ? DateTime.now() : date;
    _filterTrips();
    notifyListeners();
  }

  List<String> findAvailableDepartures() {
    return _availableBusTrips.map((trip) => trip.departure).toSet().toList();
  }

  List<String> findAvailableArrivals() {
    return _availableBusTrips
        .where((trip) => trip.departure == selectedDeparture)
        .map((trip) => trip.arrival)
        .toSet()
        .toList();
  }

  List<BusTrip> filterBusTripsByDate(final DateTime date) {
    final frequencyToDate = busFrequencyByDate(date);
    final allFiltered = _allBusTrips
        .where((busTrip) => frequencyToDate == busTrip.frequency)
        .toList();

    if (isToday(date)) {
      return allFiltered
          .where(
            (busTrip) =>
                busTrip.arrivalTime.compareTo(
                  Duration(hours: date.hour, minutes: date.minute),
                ) >=
                0,
          )
          .toList();
    }

    return allFiltered;
  }

  Future<void> saveToStorage(List<BusTrip> busTrips) async {
    await BusStorage().setBus(jsonEncode(busTrips));
  }

  void afterGetValues() {
    _isLoading = false;
    notifyListeners();
  }

  void changeArrival(String arrival) {
    selectedArrival = arrival;
    filterSelectedBusTrips();
    findLastBusTrip();
    BusStorage().setLastArrival(selectedArrival);
    notifyListeners();
  }

  void changeDeparture(String departure) {
    selectedDeparture = departure;
    availableArrivals = findAvailableArrivals();
    selectedArrival = availableArrivals[0];
    filterSelectedBusTrips();
    findLastBusTrip();
    BusStorage().setLastDeparture(selectedDeparture);
    BusStorage().setLastArrival(selectedArrival);
    notifyListeners();
  }

  void findLastBusTrip() {
    final filterArrivalAndDeparture = _availableBusTrips
        .where(
          (busTrip) =>
              busTrip.arrival == selectedArrival &&
              busTrip.departure == selectedDeparture,
        )
        .toList();

    if (isToday(selectedDate)) {
      final list = filterArrivalAndDeparture
          .where(
            (busTrip) =>
                busTrip.departureTime.compareTo(
                  Duration(
                    hours: selectedDate.hour,
                    minutes: selectedDate.minute,
                  ),
                ) <
                0,
          )
          .toList();
      if (list.isNotEmpty) {
        lastBusTrip = list.last;
      }
    } else {
      lastBusTrip = null;
    }
  }

  void filterSelectedBusTrips() {
    final filterArrivalAndDeparture = _availableBusTrips
        .where(
          (busTrip) =>
              busTrip.arrival == selectedArrival &&
              busTrip.departure == selectedDeparture,
        )
        .toList();

    if (isToday(selectedDate)) {
      _selectedBusTrips = filterArrivalAndDeparture
          .where(
            (busTrip) =>
                busTrip.departureTime.compareTo(
                  Duration(
                    hours: selectedDate.hour,
                    minutes: selectedDate.minute,
                  ),
                ) >=
                0,
          )
          .toList();
      return;
    }

    _selectedBusTrips = filterArrivalAndDeparture;
  }

  List<BusTrip> get allBusTrips => _allBusTrips;

  List<BusTrip> get selectedBusTrips => _selectedBusTrips;

  bool get isLoading => _isLoading;
}
