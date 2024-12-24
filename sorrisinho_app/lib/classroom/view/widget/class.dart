import 'package:flutter/material.dart';
import 'package:sorrisinho_app/classroom/models/class_frequency_enum.dart';
import 'package:sorrisinho_app/classroom/models/classroom.dart';
import 'package:sorrisinho_app/shared/format_text.dart';

class ClassRoomWidget extends StatelessWidget {
  final ClassRoom classRoom;

  const ClassRoomWidget({
    super.key,
    required this.classRoom,
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
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
                    margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
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
                  Container(
                    margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                    child: Text(
                      classRoom.discipline.course.toCapitalized(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
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
