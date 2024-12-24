import 'package:sorrisinho_app/classroom/models/class_frequency_enum.dart';
import 'package:sorrisinho_app/classroom/models/class_type_enum.dart';
import 'package:sorrisinho_app/classroom/models/discipline.dart';

class ClassRoom {
  final int id;
  final String weekDayName;
  final int weekDayNumber;
  final String room;
  final ClassFrequencyEnum frequency;
  final String teacher;
  final String secondaryTeacher;
  final ClassTypeEnum classType;
  final int start;
  final int end;
  final Discipline discipline;

  const ClassRoom({
    required this.id,
    required this.weekDayName,
    required this.weekDayNumber,
    required this.room,
    required this.frequency,
    required this.teacher,
    required this.secondaryTeacher,
    required this.classType,
    required this.start,
    required this.end,
    required this.discipline,
  });

  factory ClassRoom.fromJson(Map<String, dynamic> json) {
    return ClassRoom(
      id: json['id'],
      weekDayName: json['day'],
      weekDayNumber: json['weekdayNumber'],
      room: json['room'],
      frequency: json['frequency'] == 'Quinzenal I'
          ? ClassFrequencyEnum.biweeklyOne
          : json['frequency'] == 'Quinzenal II'
              ? ClassFrequencyEnum.biweeklyTwo
              : ClassFrequencyEnum.weekly,
      teacher: json['teacher'],
      secondaryTeacher: json['secondaryTeacher'],
      classType: json['type'] == 'Prática'
          ? ClassTypeEnum.practical
          : ClassTypeEnum.theory,
      start: json['start'],
      end: json['end'],
      discipline: Discipline.fromJson(json['discipline']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weekDayName': weekDayName,
      'weekDayNumber': weekDayNumber,
      'room': room,
      'frequency': frequency.name,
      'teacher': teacher,
      'secondaryTeacher': secondaryTeacher,
      'classType': classType.name,
      'start': start,
      'end': end,
      'discipline': discipline.toJson(),
    };
  }

  factory ClassRoom.decodeFromStorage(dynamic storageValue) {
    return ClassRoom(
      id: storageValue['id'],
      weekDayName: storageValue['weekDayName'],
      weekDayNumber: storageValue['weekDayNumber'],
      room: storageValue['room'],
      frequency: storageValue['frequency'] == 'biweeklyOne'
          ? ClassFrequencyEnum.biweeklyOne
          : storageValue['frequency'] == 'biweeklyTwo'
              ? ClassFrequencyEnum.biweeklyTwo
              : ClassFrequencyEnum.weekly,
      teacher: storageValue['teacher'],
      secondaryTeacher: storageValue['secondaryTeacher'],
      classType: storageValue['classType'] == 'practical'
          ? ClassTypeEnum.practical
          : ClassTypeEnum.theory,
      start: storageValue['start'],
      end: storageValue['end'],
      discipline: Discipline.decodeFromStorage(storageValue['discipline']),
    );
  }
}
