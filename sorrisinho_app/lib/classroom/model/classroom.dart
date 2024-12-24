import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sorrisinho_app/classroom/models/class_frequency_enum.dart';
import 'package:sorrisinho_app/classroom/models/classroom.dart';
import 'package:sorrisinho_app/classroom/models/discipline.dart';
import 'package:sorrisinho_app/classroom/models/nois_resolve.dart';
import 'package:sorrisinho_app/classroom/repository/classroom.dart';
import 'package:sorrisinho_app/classroom/repository/storage.dart';
import 'package:sorrisinho_app/shared/calendar_functions.dart';
import 'package:sorrisinho_app/shared/current_biweekly_enum.dart';

class ClassRoomModel extends ChangeNotifier {
  List<ClassRoom> _allClasses = [];
  Map<int, List<ClassRoom>> _allClassesBiweeklyOne = {};
  Map<int, List<ClassRoom>> _allClassesBiweeklyTwo = {};
  List<ClassRoom> _todayClasses = [];
  List<ClassRoom> _remainingTodayClasses = [];
  List<ClassRoom> _tomorrowClasses = [];
  List<Discipline> allMyDisciplines = [];
  List<int> removedDisciplines = [];
  List<int> addedDisciplines = [];
  List<Discipline> allAvailableDisciplines = [];
  List<Discipline> filteredAllAvailableDisciplines = [];
  var _isLoading = true;
  var _isRaFilled = true;
  var showTheNewsAd = false;
  var noisResolve = const NoisResolve(text: '', link: '');
  var ra = '';

  Future<void> initialLoad() async {
    final ra = await ClassRoomStorage().getRa();

    if (ra.isNotEmpty) {
      _isRaFilled = true;

      final findRemovedDisciplines =
          await ClassRoomStorage().getRemovedDisciplines();
      if (findRemovedDisciplines.isNotEmpty) {
        removedDisciplines =
            (jsonDecode(findRemovedDisciplines) as List<dynamic>)
                .map((e) => e as int)
                .toList();
      }

      final savedClassrooms = await ClassRoomStorage().getClassrooms();
      if (savedClassrooms.isNotEmpty) {
        _allClasses = (jsonDecode(savedClassrooms) as List<dynamic>)
            .map((e) => ClassRoom.decodeFromStorage(e))
            .where(
              (classRoom) =>
                  !removedDisciplines.contains(classRoom.discipline.id),
            )
            .toList();
        allMyDisciplines = _allClasses
            .map((classRoom) => classRoom.discipline)
            .toSet()
            .toList();
        afterGetValues();
      }

      try {
        final findAddedDisciplines =
            await ClassRoomStorage().getAddedDisciplines();
        if (findAddedDisciplines.isNotEmpty) {
          addedDisciplines = (jsonDecode(findAddedDisciplines) as List<dynamic>)
              .map((e) => e as int)
              .toList();
        }

        final response = (await ClassRoomRepository().fetchAllMyClasses(
          int.parse(ra),
          addedDisciplines,
        ))
            .where(
              (classRoom) =>
                  !removedDisciplines.contains(classRoom.discipline.id),
            )
            .toList();
        saveToStorage(response);
        _allClasses = response;
        allMyDisciplines = _allClasses
            .map((classRoom) => classRoom.discipline)
            .toSet()
            .toList();

        showTheNewsAd = await ClassRoomRepository().theNews();
        noisResolve = await ClassRoomRepository().fetchNoisResolve(
          int.parse(ra),
          addedDisciplines,
        );

        afterGetValues();
      } catch (_) {}
    } else {
      _isRaFilled = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  void afterGetValues() {
    _allClassesBiweeklyOne =
        _findClassesByBiweekly(ClassFrequencyEnum.biweeklyOne);
    _allClassesBiweeklyTwo =
        _findClassesByBiweekly(ClassFrequencyEnum.biweeklyTwo);
    _todayClasses = _findTodayClasses();
    _remainingTodayClasses = _findRemainingTodayClasses();
    _tomorrowClasses = _findTomorrowClasses();
    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    _remainingTodayClasses = _findRemainingTodayClasses();
    _tomorrowClasses = _findTomorrowClasses();
    notifyListeners();
  }

  Future<void> saveToStorage(List<ClassRoom> classrooms) async {
    await ClassRoomStorage().setClassrooms(jsonEncode(classrooms));
  }

  Future<void> fetchAllDisciplines() async {
    allAvailableDisciplines = await ClassRoomRepository().fetchAllDisciplines();
    filteredAllAvailableDisciplines = allAvailableDisciplines;
    notifyListeners();
  }

  void filterAllAvailableDisciplines(final String text) {
    if (text.isNotEmpty) {
      filteredAllAvailableDisciplines = allAvailableDisciplines
          .where(
            (discipline) =>
                discipline.name.toLowerCase().contains(text.toLowerCase()),
          )
          .toList();
    } else {
      filteredAllAvailableDisciplines = allAvailableDisciplines;
    }

    notifyListeners();
  }

  Future<void> removeDiscipline(final Discipline discipline) async {
    removedDisciplines.add(discipline.id);
    addedDisciplines.remove(discipline.id);
    ClassRoomStorage().setRemovedDisciplines(removedDisciplines.toString());
    ClassRoomStorage().setAddedDisciplines(addedDisciplines.toString());

    final savedClassrooms = await ClassRoomStorage().getClassrooms();
    if (savedClassrooms.isNotEmpty) {
      _allClasses = (jsonDecode(savedClassrooms) as List<dynamic>)
          .map((e) => ClassRoom.decodeFromStorage(e))
          .where(
            (classRoom) =>
                !removedDisciplines.contains(classRoom.discipline.id),
          )
          .toList();
      allMyDisciplines =
          _allClasses.map((classRoom) => classRoom.discipline).toSet().toList();
      afterGetValues();
    }
  }

  Future<void> addDiscipline(final Discipline discipline) async {
    removedDisciplines.remove(discipline.id);
    addedDisciplines.add(discipline.id);
    await ClassRoomStorage()
        .setRemovedDisciplines(removedDisciplines.toString());
    await ClassRoomStorage().setAddedDisciplines(addedDisciplines.toString());

    _isLoading = true;
    notifyListeners();

    await initialLoad();
  }

  Map<int, List<ClassRoom>> _findClassesByBiweekly(
    ClassFrequencyEnum frequency,
  ) {
    final Map<int, List<ClassRoom>> classesMap = {
      1: _findClassesByDay(weekDayNumer: 1, classFrequency: frequency),
      2: _findClassesByDay(weekDayNumer: 2, classFrequency: frequency),
      3: _findClassesByDay(weekDayNumer: 3, classFrequency: frequency),
      4: _findClassesByDay(weekDayNumer: 4, classFrequency: frequency),
      5: _findClassesByDay(weekDayNumer: 5, classFrequency: frequency),
      6: _findClassesByDay(weekDayNumer: 6, classFrequency: frequency),
    };

    classesMap.removeWhere((weekDay, classes) => classes.isEmpty);

    return classesMap;
  }

  List<ClassRoom> _findTodayClasses() {
    final currentClassFrequencyBiweekly =
        findCurrentBiweekly() == CurrentBiweekly.one
            ? ClassFrequencyEnum.biweeklyOne
            : ClassFrequencyEnum.biweeklyTwo;

    return _findClassesByDay(
      weekDayNumer: DateTime.now().weekday,
      classFrequency: currentClassFrequencyBiweekly,
    );
  }

  List<ClassRoom> _findRemainingTodayClasses() {
    final int currentHour = DateTime.now().hour;
    final allClassesToday = _findTodayClasses();
    allClassesToday.removeWhere((classRoom) => currentHour >= classRoom.end);
    return allClassesToday;
  }

  List<ClassRoom> _findTomorrowClasses() {
    final tomorrowDate = DateTime.now().add(const Duration(days: 1));

    final currentClassFrequencyBiweekly =
        findCurrentBiweekly(date: tomorrowDate) == CurrentBiweekly.one
            ? ClassFrequencyEnum.biweeklyOne
            : ClassFrequencyEnum.biweeklyTwo;

    return _findClassesByDay(
      weekDayNumer: tomorrowDate.weekday,
      classFrequency: currentClassFrequencyBiweekly,
    );
  }

  List<ClassRoom> _findClassesByDay({
    required int weekDayNumer,
    required ClassFrequencyEnum classFrequency,
  }) {
    final foundClasses = _allClasses
        .where(
          (classroom) =>
              (classroom.frequency == ClassFrequencyEnum.weekly ||
                  classroom.frequency == classFrequency) &&
              classroom.weekDayNumber == weekDayNumer,
        )
        .toList();

    _orderClasses(foundClasses);

    return foundClasses;
  }

  void _orderClasses(List<ClassRoom> classes) =>
      classes.sort((a, b) => a.start.compareTo(b.start));

  Map<int, List<ClassRoom>> get weekClasses =>
      findCurrentBiweekly() == CurrentBiweekly.one
          ? _allClassesBiweeklyOne
          : _allClassesBiweeklyTwo;

  Future<bool> saveRa(String ra) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<ClassRoom> classRooms =
          await ClassRoomRepository().fetchAllMyClasses(
        int.parse(ra),
        addedDisciplines,
      );
      if (ra.contains('2024') && classRooms.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        await ClassRoomStorage().setRa(ra);
        await initialLoad();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteRa() async {
    final ra = await ClassRoomStorage().getRa();
    await ClassRoomRepository().deleteCustomEnrollments(int.parse(ra));
    await ClassRoomStorage().setRa('');
    await ClassRoomStorage().setRemovedDisciplines('');
    await ClassRoomStorage().setAddedDisciplines('');
    await ClassRoomStorage().setClassrooms('');
    _isLoading = true;
    notifyListeners();
    await initialLoad();
  }

  Future<bool> insertSigaaText(String ra, String sigaaText) async {
    final response =
        await ClassRoomRepository().makeEnrollments(int.parse(ra), sigaaText);

    if (response) {
      saveRa(ra);
      return true;
    } else {
      return false;
    }
  }

  Map<int, List<ClassRoom>> get allClassesWeeklyOne => _allClassesBiweeklyOne;

  Map<int, List<ClassRoom>> get allClassesWeeklyTwo => _allClassesBiweeklyTwo;

  List<ClassRoom> get todayClasses => _todayClasses;

  List<ClassRoom> get tomorrowClasses => _tomorrowClasses;

  List<ClassRoom> get remainingTodayClasses => _remainingTodayClasses;

  List<ClassRoom> get allMyClasses => _allClasses;

  bool get isLoading => _isLoading;

  bool get isRaFilled => _isRaFilled;
}
