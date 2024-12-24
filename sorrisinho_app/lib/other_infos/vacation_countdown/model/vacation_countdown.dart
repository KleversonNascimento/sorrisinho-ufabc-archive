import 'package:flutter/material.dart';

class VacationCountdownModel extends ChangeNotifier {
  Duration _timeToVacation = Duration.zero;

  void initialLoad() {
    final vacationDate = DateTime(2023, 08, 18);

    _timeToVacation = vacationDate.difference(DateTime.now());

    notifyListeners();

    scheduleUpdate();
  }

  Future<void> scheduleUpdate() async {
    await Future.delayed(const Duration(seconds: 1));
    initialLoad();
  }

  Duration get timeToVacation => _timeToVacation;
}
