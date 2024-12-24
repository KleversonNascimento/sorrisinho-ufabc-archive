import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/classroom/models/class_frequency_enum.dart';
import 'package:sorrisinho_app/classroom/models/classroom.dart';
import 'package:sorrisinho_app/home/view_model/home.dart';
import 'package:sorrisinho_app/shared/theme.dart';

class ClassRoomHomeWidget extends StatelessWidget {
  final List<ClassRoom> todayClasses;
  final List<ClassRoom> tomorrowClasses;

  const ClassRoomHomeWidget({
    super.key,
    required this.todayClasses,
    required this.tomorrowClasses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              width: MediaQuery.of(context).size.width - 48,
              child: const Text(
                'Próximas aulas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              width: MediaQuery.of(context).size.width - 48,
              child: Text(
                buildSubtitle(todayClasses, tomorrowClasses),
                style: TextStyle(
                  fontSize: 14,
                  color: SorrisinhoTheme.informationBackgroundColor,
                ),
              ),
            ),
            todayClasses.isNotEmpty
                ? TodayClassesWidget(
                    todayClasses: todayClasses,
                  )
                : const SizedBox.shrink(),
            tomorrowClasses.isNotEmpty
                ? TomorrowClassesWidget(
                    tomorrowClasses: tomorrowClasses,
                  )
                : const SizedBox.shrink(),
            Container(
              margin: const EdgeInsetsDirectional.only(bottom: 4),
            ),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () =>
                      context.read<HomeViewModel>().changeSelectedScreen(1),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                    child: const Text(
                      'Ver todas as aulas >',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String buildSubtitle(
  final List<ClassRoom> todayClasses,
  final List<ClassRoom> tomorrowClasses,
) {
  if (todayClasses.isEmpty) {
    if (tomorrowClasses.length > 1) {
      return 'Você tem ${tomorrowClasses.length} aulas amanhã';
    }

    return 'Você tem uma aula amanhã';
  }

  if (tomorrowClasses.isEmpty) {
    if (todayClasses.length > 1) {
      return 'Você tem ${todayClasses.length} aulas hoje';
    }

    return 'Você tem uma aula hoje';
  }

  if (todayClasses.length > 1) {
    return 'Você tem ${todayClasses.length} aulas hoje e '
        '${tomorrowClasses.length} amanhã';
  }

  return 'Você tem ${todayClasses.length} aula hoje e '
      '${tomorrowClasses.length} amanhã';
}

String getFormattedHour(int hour) {
  if (hour.toString().length > 1) {
    return hour.toString();
  }

  return '0${hour.toString()}';
}

String getFrequencyText(ClassFrequencyEnum classFrequency) {
  if (classFrequency == ClassFrequencyEnum.biweeklyOne) {
    return 'Quinzenal I';
  }

  if (classFrequency == ClassFrequencyEnum.biweeklyTwo) {
    return 'Quinzenal II';
  }

  return 'Semanal';
}

class TodayClassesWidget extends StatelessWidget {
  final List<ClassRoom> todayClasses;

  const TodayClassesWidget({
    super.key,
    required this.todayClasses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 6, 8, 0),
          width: MediaQuery.of(context).size.width - 48,
          child: const Text(
            'Hoje',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        ...todayClasses
            .map((classRoom) => ClassWidget(classRoom: classRoom))
            .toList()
      ],
    );
  }
}

class TomorrowClassesWidget extends StatelessWidget {
  final List<ClassRoom> tomorrowClasses;

  const TomorrowClassesWidget({
    super.key,
    required this.tomorrowClasses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 6, 8, 0),
          width: MediaQuery.of(context).size.width - 48,
          child: const Text(
            'Amanhã',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        ...tomorrowClasses
            .map((classRoom) => ClassWidget(classRoom: classRoom))
            .toList()
      ],
    );
  }
}

class ClassWidget extends StatelessWidget {
  final ClassRoom classRoom;

  const ClassWidget({
    super.key,
    required this.classRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 2, 8, 0),
          width: MediaQuery.of(context).size.width - 48,
          child: Text(
            '${classRoom.discipline.name} - ${classRoom.discipline.classCode}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Text(
            '${getFormattedHour(classRoom.start)}h às '
            '${getFormattedHour(classRoom.end)}h - '
            '${getFrequencyText(classRoom.frequency)}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Text(
            '${classRoom.room}, ${classRoom.discipline.campus}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 4),
          width: MediaQuery.of(context).size.width - 48,
          child: Text(
            classRoom.secondaryTeacher.length > 2
                ? '${classRoom.teacher} e ${classRoom.secondaryTeacher}'
                : classRoom.teacher,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
